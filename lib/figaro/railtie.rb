require "rails"
require "yaml"

module Figaro
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      ENV.update(Figaro.env) { |key, left, right| left || right }
    end

    rake_tasks do
      load "figaro/tasks.rake"
    end
  end
end
