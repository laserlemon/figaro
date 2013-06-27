require "rails"
require "yaml"

module Figaro
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      Figaro.env.each do |key, value|
        ENV[key] = value unless ENV.key?(key)
      end
    end

    rake_tasks do
      load "figaro/tasks.rake"
    end
  end
end
