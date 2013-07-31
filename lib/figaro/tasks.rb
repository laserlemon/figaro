require "bundler"

module Figaro
  module Tasks
    class Heroku < Struct.new(:app)
      def invoke
        heroku("config:set #{vars}")
      end

      def vars
        Figaro.env(environment).map { |key, value|
          if value.start_with? '['   
            value = "'#{value.gsub('"', '')}'"
          elsif value.include? ' ' 
            value = "'#{value}'" 
          end
          "#{key}=#{value}"
        }.sort.join(" ")
      end

      def environment
        heroku("run 'echo $RAILS_ENV'").chomp[/(\w+)\z/]
      end

      def heroku(command)
        with_app = app ? " --app #{app}" : ""
        `heroku #{command}#{with_app}`
      end

      def `(command)
        Bundler.with_clean_env { super }
      end
    end
  end
end
