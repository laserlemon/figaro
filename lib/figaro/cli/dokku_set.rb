require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class DokkuSet < Task
      def run
        system(configuration, command)
      end

      private

      def command
        "dokku #{ssh_creds} config:set #{for_app} #{vars}"
      end

      def ssh_creds
        # hard code the dokku user because a non-dokku user requires the 'dokku' command
        # TODO: support alternative users and automatically add the 'dokku' command
        options[:server] ? "dokku@#{options[:server]}" : nil
      end

      def for_app
        options[:app] ? "#{options[:app]}" : nil
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
