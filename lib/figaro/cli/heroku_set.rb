require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class HerokuSet < Task
      def run
        system(configuration, command)
      end

      private

      def command
        "heroku config:set #{vars} #{for_app}"
      end

      def for_app
        options[:app] ? "--app=#{options[:app]}" : nil
      end

      def vars
        configuration.map {|k, v| var(k, v) }.join(" ")
      end

      def var(key, value)
        Gem.win_platform? ? %(#{key}="%#{value}%") : %(#{key}="#{value}")
      end
    end
  end
end
