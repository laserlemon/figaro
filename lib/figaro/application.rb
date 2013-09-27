require "erb"
require "yaml"

require "figaro/error"

module Figaro
  class Application
    attr_writer :path, :environment

    def initialize(options = {})
      @path = options[:path]
      @environment = options[:environment]
    end

    def path
      (@path || default_path).to_s
    end

    def environment
      (@environment || default_environment).to_s
    end

    def configuration
      global_configuration.merge(environment_configuration)
    end

    def load
      configuration.each do |key, value|
        set(key, value) unless skip?(key)
      end
    end

    private

    def default_path
      rails_not_initialized! unless Rails.root

      Rails.root.join("config", "application.yml")
    end

    def default_environment
      Rails.env
    end

    def raw_configuration
      (@parsed ||= Hash.new { |hash, path| hash[path] = parse(path) })[path]
    end

    def parse(path)
      File.exist?(path) && YAML.load(ERB.new(File.read(path)).result) || {}
    rescue YAML::Error => error
      invalid_yaml!(error)
    end

    def global_configuration
      raw_configuration.reject { |_, value| value.is_a?(Hash) }
    end

    def environment_configuration
      raw_configuration.fetch(environment) { {} }
    end

    def set(key, value)
      non_string_configuration!(key) unless key.is_a?(String)
      non_string_configuration!(value) unless value.is_a?(String)

      ::ENV[key.to_s] = value.to_s
    end

    def skip?(key)
      ::ENV.key?(key.to_s)
    end

    def rails_not_initialized!
      raise RailsNotInitialized
    end

    def invalid_yaml!(error)
      invalid_yaml = InvalidYAML.new(error.message)
      invalid_yaml.set_backtrace(error.backtrace)
      raise invalid_yaml
    end

    def non_string_configuration!(value)
      warn "WARNING: Use strings for Figaro configuration. #{value.inspect} was converted to #{value.to_s.inspect}."
    end
  end
end
