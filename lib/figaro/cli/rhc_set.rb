require 'figaro/cli/task'

module Figaro
  class CLI < Thor
    # Send Figaro configuration to OpenShift
    class RhcSet < Task
      def run
        system(configuration, command)
      end

      private

      def command
        "rhc env-set #{vars} #{for_app} #{for_namespace}"
      end

      def for_app
        options[:app] ? "--app #{options[:app]}" : nil
      end

      def for_namespace
        options[:namespace] ? "--namespace #{options[:namespace]}" : nil
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
