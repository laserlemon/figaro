require "rails"
require "yaml"

module Figaro
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      Figaro.env.each do |name, value|
        ENV[name] = value unless ENV.key?(name)
      end
    end

    rake_tasks do
      load "figaro/tasks.rake"
    end
  end
end
