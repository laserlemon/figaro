module Figaro
  module Tasks
    RESPONSE_HEADER_LINE_COUNT = 1

    def self.heroku(app = nil)
      with_app = app ? " --app #{app}" : ""

      shell_command = 'heroku run "echo \$RAILS_ENV"'
      response = Bundler.with_clean_env{`#{shell_command}`}
      rails_env = response.lines.drop(RESPONSE_HEADER_LINE_COUNT).join('').strip
# STDOUT.print "rails_env is #{rails_env}\n"

      vars = Figaro.vars(rails_env.presence)

      Bundler.with_clean_env{`heroku config:add #{vars}#{with_app}`}
    end
  end
end
