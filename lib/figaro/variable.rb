module Figaro
  class Variable
    attr_reader :config, :name, :options, :key

    def initialize(config, name, options)
      @config, @name, @options = config, name, options
      @key = options.fetch(:from) { name.to_s.upcase }
      @default = options[:default]
      @required = options.fetch(:required, true)
    end

    def load(value)
      value
    end

    def dump(value)
      value.nil? ? nil : value.to_s
    end

    def value
      load(config.get(key) { default })
    end

    def value=(value)
      config.set(key, dump(value))
    end

    def value?
      !!value
    end

    def default
      config.evaluate(@default)
    end

    def required?
      !!config.evaluate(@required)
    end
  end
end
