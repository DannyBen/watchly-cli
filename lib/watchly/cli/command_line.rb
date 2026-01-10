module Watchly
  module CLI
    class CommandLine
      def self.router
        MisterBin::Runner.new version: "#{VERSION} (watchly #{Watchly::VERSION})",
          header: 'watchly',
          handler: Command
      end
    end
  end
end
