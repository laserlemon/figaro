require "erb"
require "yaml"

module Figaro
  class Application
    FIGARO_ENV_PREFIX = "_FIGARO_"
    SILENCE_STRING_WARNINGS_KEY = :FIGARO_SILENCE_STRING_WARNINGS

    include Enumerable

    def initialize(options = {})
      @options = options.inject({}) { |m, (k, v)| m[k.to_sym] = v; m }
    end

    def path
      @options.fetch(:path) { default_path }.to_s
    end

    def path=(path)
      @options[:path] = path
    end

    def environment
      environment = @options.fetch(:environment) { default_environment }
      environment.nil? ? nil : environment.to_s
    end

    def environment=(environment)
      @options[:environment] = environment
    end

    def configuration
      global_configuration.merge(environment_configuration)
    end

    def load
      each do |key, value|
        skip?(key) ? key_skipped!(key) : set(key, value)
      end
    end

    def each(&block)
      configuration.each(&block)
    end

    private

    def default_path
      raise NotImplementedError
    end

    def default_environment
      nil
    end

    def raw_configuration
      (@parsed ||= Hash.new { |hash, path| hash[path] = parse(path) })[path]
    end

    def parse(path)
      File.exist?(path) && YAML.load(ERB.new(File.read(path)).result) || {}
    end

    def global_configuration
      raw_configuration.reject { |_, value| value.is_a?(Hash) }
    end

    def environment_configuration
      raw_configuration[environment] || {}
    end

    def set(key, value)
      unless non_string_warnings_silenced?
        non_string_configuration!(key) unless key.is_a?(String)
        non_string_configuration!(value) unless value.is_a?(String) || value.nil?
      end

      ::ENV[key.to_s] = value.nil? ? nil : value.to_s
      ::ENV[FIGARO_ENV_PREFIX + key.to_s] = value.nil? ? nil: value.to_s
    end

    def skip?(key)
      ::ENV.key?(key.to_s) && !::ENV.key?(FIGARO_ENV_PREFIX + key.to_s)
    end

    def non_string_warnings_silenced?
      key = SILENCE_STRING_WARNINGS_KEY

      # Allow the silence configuration itself to use non-string keys/values.
      configuration.values_at(key.to_s, key).any? { |cv| cv.to_s == 'true' }
    end

    def non_string_configuration!(value)
      warn "WARNING: Use strings for Figaro configuration. #{value.inspect} was converted to #{value.to_s.inspect}."
    end

    def key_skipped!(key)
      warn "WARNING: Skipping key #{key.inspect}. Already set in ENV."
    end
  end
end
