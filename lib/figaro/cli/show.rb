require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class Show < Task
      def run
        longest_key = configuration.keys.max { |key| key.length }
        padding = (longest_key.length + 3)
        configuration.sort_by { |k, v| k }.each do |k, v|
          puts "%- #{padding}s: %s" % [k, v]
        end
      end
    end
  end
end
