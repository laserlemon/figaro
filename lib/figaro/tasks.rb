require "open3"

module Figaro
  module Tasks
    def self.heroku(app = nil)
      with_app = app ? " --app #{app}" : ""

      rails_env = Open3.capture2("heroku config:get RAILS_ENV#{with_app}")
      vars = Figaro.vars(rails_env.presence)

      Open3.capture2("heroku config:add #{vars}#{with_app}")
    end
  end
end
