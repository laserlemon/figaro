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

      def show(io = $stdout)
        data = Figaro.env(environment)
        maxl = data.keys.map(&:size).max

        io.puts "=== PROPOSED #{app || 'default'} Config Vars"
        data.keys.sort.each { |k|
          pk = "#{k}:"
          io.puts "#{pk.ljust(maxl + 1)} #{data[k]}"
        }
      end

      def diff
        app_name = app || 'default'

        current_config  = Rails.root.join('tmp', "#{app}.config")
        proposed_config = Rails.root.join('tmp', "#{app}.proposed")

        File.open(current_config, 'w') { |f|
          f.puts heroku("config")
        }

        File.open(proposed_config, 'w') { |f|
          show(f)
        }

        system 'git', 'diff', '--no-index', current_config.to_path,
          proposed_config.to_path
      ensure
        current_config.unlink if current_config.exist?
        proposed_config.unlink if proposed_config.exist?
      end
    end
  end
end
