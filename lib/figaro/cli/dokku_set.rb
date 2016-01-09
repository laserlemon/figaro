require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class DokkuSet < Task
      def run
        system(configuration, command)
      end

      private

      def command
        "dokku config:set #{vars}"
      end

      def vars
        configuration.keys.map { |k| var(k) }.join(" ")
      end

      def var(key)
        Gem.win_platform? ? %(#{key}="%#{key}%") : %(#{key}="$#{key}")
      end
    end
  end
end
