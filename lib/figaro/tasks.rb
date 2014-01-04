require "bundler"

module Figaro
  module Tasks
    class Heroku < Struct.new(:app)
      def invoke
        heroku("config:set #{vars}")
      end

      def heroku(command)
        with_app = app ? " --app #{app}" : ""
        `heroku #{command}#{with_app}`
      end

      def `(command)
        Bundler.with_clean_env { super }
      end

      def vars
        application.map { |key, value|
          "#{key}=#{Shellwords.escape(value)}"
        }.sort.join(" ")
      end

      def application
        Figaro.backend.new(environment: environment)
      end

      def environment
        heroku("run 'echo $RAILS_ENV'").chomp[/(\w+)\z/]
      end
    end
  end
end
