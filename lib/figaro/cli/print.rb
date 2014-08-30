require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class Print < Task
      def run
        puts vars
      end

      def vars
        configuration.map{ |k,v| %(#{k}=#{v}) }.join("\n")
      end
    end
  end
end
