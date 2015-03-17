require 'figaro/cli/task'

module Figaro
  class CLI < Thor
    class EbSet < Task
      def run
        system(configuration, command)
      end

      private

      def command
        "eb setenv #{vars} #{for_env} #{for_profile} #{verbose}"
      end

      def for_env
        options[:env] ? "-e #{options[:env]}" : nil
      end

      def for_profile
        options[:profile] ? "--profile #{options[:profile]}" : nil
      end

      def verbose
        options[:verbose] ? '--verbose' : nil
      end

      def vars
        configuration.keys.map { |k| var(k) }.join(' ')
      end

      def var(key)
        Gem.win_platform? ? %(#{key}="%#{key}%") : %(#{key}="$#{key}")
      end
    end
  end
end
