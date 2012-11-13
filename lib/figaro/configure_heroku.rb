module Figaro
  class ConfigureHeroku
    def execute(args = {})

      puts "I'm being executed!!!"

      app = args[:app] ? " --app #{args[:app]}" : ""
      rails_env = `heroku config:get RAILS_ENV#{app}`
      Rails.env = rails_env if rails_env.present?
      `heroku config:add #{Figaro.vars}#{app}`
    end
  end
end