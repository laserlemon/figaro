require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class ConfigsDump < Task
      def run
        puts command
      end

      private

      def command
        # system(configuration, "printf \"#{app_name} #{vars}\"")
        # "printf \"config:set save_kittens #{vars} #{for_app} #{for_remote}\n\""

        env_vars = configuration.map { |k,v| "#{k.to_s}=\"#{v.to_s.gsub(" ", "\\ ")}\"" unless v.nil? }.join(" ")
        "#{dokku_alias} #{app_name} #{env_vars}"
      end

      def app_name
        options[:app_name] ? "config:set #{options[:app_name]}" : nil
      end

      def dokku_alias
        options[:dokku_alias] ? "#{options[:dokku_alias]}" : nil
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
