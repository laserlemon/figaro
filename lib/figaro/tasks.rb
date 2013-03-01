module Figaro
  module Tasks
    def self.heroku(app = nil)
      with_app = app ? " --app #{app}" : ""

      rails_env = Bundler.with_clean_env{`heroku config:get RAILS_ENV#{with_app}`}.chomp
      vars = Figaro.vars(rails_env.presence)

      Bundler.with_clean_env{`heroku config:add #{vars}#{with_app}`}
    end
  end
end
