module Watchly
  module CLI
    class CommandLine
      def self.router
        MisterBin::Runner.new handler: Command
      end
    end
  end
end
