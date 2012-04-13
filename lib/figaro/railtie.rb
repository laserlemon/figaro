require "rails"
require "yaml"

module Figaro
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      path = Rails.root.join("config/application.yml")
      if File.exist?(path)
        loader = Loader.new(path)
        ENV.update(loader.to_hash)
      end
    end
  end

  class Loader
    def initialize(path)
      @config = YAML.load(File.read(path)) || {}
    end

    def to_hash
      build_hash_from_enviroment
    end

    def enviroment
      ENV['RAILS_ENV'] || ENV['RACK_ENV']
    end

    def build_hash_from_enviroment
      @config.keys.each do |key|
        if @config.fetch(key).respond_to?(:each)
          values = @config.delete(key)
          if key == enviroment
            @config.update(values)
          end
        end
      end
      @config
    end
  end
end
