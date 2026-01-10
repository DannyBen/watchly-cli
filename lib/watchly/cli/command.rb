require 'mister_bin'

module Watchly
  module CLI
    class Command < MisterBin::Command
      summary 'watchly — run a command when files change'
      version "#{VERSION} (watchly #{Watchly::VERSION})"

      help <<~HELP
        Watches files matching one or more glob patterns and runs a command when
        they change.

        When the command runs, environment variables are set with the list of
        changed files (see below).
      HELP

      usage 'watchly COMMAND [options] [GLOB...]'
      usage 'watchly --version | --help'

      param 'COMMAND', 'Command to run on change'
      param 'GLOB', 'One or more glob patterns [default: *.*]'

      option '-i --interval N', 'Loop interval in seconds [default: 1]'
      option '-q --quiet', 'Print less to screen'
      option '-e --each', 'Run the command once per added or changed file'
      option '-m --immediate', 'Execute the command before watching'

      environment 'WATCHLY_FILES', 'Added and modified files, one per line'
      environment 'WATCHLY_ADDED', 'Added files, one per line'
      environment 'WATCHLY_MODIFIED', 'Modified files, one per line'
      environment 'WATCHLY_REMOVED', 'Removed files, one per line'
      environment 'WATCHLY_FILE', 'The file currently being processed (only with --each)'

      example %[watchly 'echo "$WATCHLY_FILES"' 'spec/**/*.rb' 'lib/**/*.*']

      def run
        run_command if immediate?
        watch
      rescue Interrupt
        say "\ngoodbye"
      end

    private

      def watch
        say 'watching...'
        watcher.on_change do |changes|
          show_changes changes unless quiet?

          if each?
            run_each(changes)
          else
            run_command env_from_changes(changes)
          end
        end
      end

      def env_from_changes(changes)
        {
          'WATCHLY_FILES'    => changes.files.join("\n"),
          'WATCHLY_ADDED'    => changes.added.join("\n"),
          'WATCHLY_MODIFIED' => changes.modified.join("\n"),
          'WATCHLY_REMOVED'  => changes.removed.join("\n"),
        }
      end

      def show_changes(changes)
        changes.added.each    { say "gb`+ #{it}`" }
        changes.modified.each { say "bb`* #{it}`" }
        changes.removed.each  { say "rb`- #{it}`" }
      end

      def run_command(env = {})
        success = system env, command
        { status: success ? 0 : 1 }
      end

      def run_each(changes)
        changes.files.each do |file|
          env = env_from_changes(changes).merge('WATCHLY_FILE' => file)
          run_command(env)
        end
      end

      def watcher = @watcher ||= Watchly::Watcher.new(globs, interval:)

      def command = args['COMMAND']
      def globs = args['GLOB'] || '*.*'
      def interval = args['--interval'].to_i
      def quiet? = args['--quiet']
      def each? = args['--each']
      def immediate? = args['--immediate']
    end
  end
end
