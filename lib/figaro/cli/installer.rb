require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class Installer < Task
      def run
        system(command)
      end

      private
      
      def command
        "rails generate figaro:install #{Thor::Options.to_switches(options)}"
      end

    end
  end
end
