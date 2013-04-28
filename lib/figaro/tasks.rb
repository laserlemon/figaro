require "bundler"
require "stringio"

module Figaro
  module Tasks
    class Heroku < Struct.new(:app)
      def invoke
        heroku("config:set #{vars}")
      end

      def pull
        File.open(config, "a") { |f| f.puts pulled_vars }
      end

      def pulled_vars
        StringIO.open(heroku("config")) { |io| parse(io) }
      end

      def parse(io)
        str = ""; while line = io.gets; filter(line, str); end; str
      end

      def filter(line, str)
        str << line if line !~ /(Config Vars|postgres:\/\/)/
      end

      def config
        Rails.root.join("config", "application.yml")
      end

      def vars
        Figaro.vars(environment)
      end

      def environment
        heroku("run 'echo $RAILS_ENV'").chomp[/(\w+)\z/]
      end

      def heroku(command, option=nil)
        with_app = app ? " --app #{app}" : ""
        `heroku #{command}#{with_app}`
      end

      def `(command)
        Bundler.with_clean_env { super }
      end
    end
  end
end