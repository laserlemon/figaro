require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class EBSet < Task
      def run
        system(configuration, command)
      end

      private

      def command
        "eb setenv #{vars} #{for_eb_environment} #{for_profile} #{for_region} " \
          "#{for_timeout} #{for_verify_ssl}"
      end

      def for_eb_environment
        options[:'eb-env'] ? "--environment=#{options[:'eb-env']}" : nil
      end

      def for_profile
        options[:profile] ? "--profile=#{options[:profile]}" : nil
      end

      def for_region
        options[:region] ? "--region=#{options[:region]}" : nil
      end

      def for_timeout
        options[:timeout] ? "--timeout=#{options[:timeout]}" : nil
      end

      def for_verify_ssl
        !options[:'verify-ssl'] ? "--no-verify-ssl" : nil
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
