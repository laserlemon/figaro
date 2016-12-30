require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class HerokuSet < Task
      def run
        config = configuration
        config.each do |k, v|
          config[k] = v.to_s
        end
        system(config, command)
      end

      private

      def command
        "heroku config:set #{vars} #{for_app} #{for_remote}"
      end

      def for_app
        options[:app] ? "--app=#{options[:app]}" : nil
      end

      def for_remote
        options[:remote] ? "--remote=#{options[:remote]}" : nil
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
