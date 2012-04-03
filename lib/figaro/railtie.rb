require "rails"
require "yaml"

module Figaro
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      ENV.update(Figaro.env)
    end
  end
end
