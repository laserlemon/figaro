require "bundler"

module Figaro
  module Tasks
    class Heroku < Struct.new(:app)
      def invoke
        heroku("config:set #{vars}")
      end

      def vars
        Figaro.vars(environment)
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
