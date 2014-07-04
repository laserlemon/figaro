require "figaro/cli/task"

module Figaro
  class CLI < Thor
    class TravisEncrypt < Task
      def run
        system(command)
      end

      private

      def command
        %(travis encrypt #{travis_options} "#{vars}")
      end

      def travis_options
        options_ary = options[:extra_args]

        if !options_ary.include?('--no-split') && !options_ary.include?('--split')
          options_ary << '--split'
        end

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
