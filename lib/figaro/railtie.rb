require "rails"
require "yaml"

module Figaro
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      ENV.update(Loader.new.shmush)
    end

    rake_tasks do
      load "figaro/tasks.rb"
    end
  end


  class Loader
    def initialize
      @config = Figaro.env
    end

    def shmush
      build_hash_from_enviroment
    end

    private
    def enviroment
      ENV['RAILS_ENV'] || ENV['RACK_ENV']
    end

    def build_hash_from_enviroment
      @config.keys.each do |key|
        if ["Hash", "Array"].include?(@config.fetch(key).class.to_s)
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
