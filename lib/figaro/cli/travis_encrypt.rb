require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class TravisEncrypt < Task
      def run
        system(command)
      end

      private

      def command
        %(travis encrypt #{travis_options} --split "#{vars}")
      end

      def travis_options
        options_ary = []
        if options[:add]
          options_ary << '--add'

          if options[:override]
            options_ary << '--override'
          end
        end

        options_ary.join(' ')
      end

      def vars
        configuration.map{ |k,v| %(#{k}=#{v}) }.join("\n")
      end
    end
  end
end
