module Figaro
  class ConfigureHeroku
    def execute(args = {})
      app = args[:app] ? " --app #{args[:app]}" : ""
      rails_env = `heroku config:get RAILS_ENV#{app}`
      Rails.env = rails_env.strip if rails_env.present?
      `heroku config:add #{Figaro.vars}#{app}`
    end
  end
end