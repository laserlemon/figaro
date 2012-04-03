require "rails"
require "yaml"

module Figaro
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      path = Rails.root.join("config/application.yml")
      ENV.update(YAML.load_file(path) || {}) if File.exist?(path)
    end
  end
end
