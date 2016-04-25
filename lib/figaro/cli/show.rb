require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class Show < Task
      def run
        configuration.sort_by{ |k, v| k }.each do |k, v|
          puts "#{k}=#{v}"
        end
      end
    end
  end
end
