require "bundler"

module Figaro
  module Tasks
    class Heroku < Struct.new(:app)
      def invoke
        heroku("config:set #{vars}")
      end

      def pull
        heroku("config", :pull)
      end

      def vars
        Figaro.vars(environment)
      end

      def environment
        heroku("run 'echo $RAILS_ENV'").chomp[/(\w+)\z/]
      end

      def redirect(arg)
        arg.eql?(:pull) ? append : ""
      end

      def append
        "| #{pattern} >> #{file}"
      end

      def pattern
        "grep -v -E 'Config Vars|postgres://'"
      end

      def file
        Rails.root.join("config", "application.yml")
      end

      def heroku(command, option=nil)
        with_app = app ? " --app #{app}" : ""
        `heroku #{command}#{with_app}#{redirect(option)}`
      end

      def `(command)
        Bundler.with_clean_env { super }
      end
    end
  end
end