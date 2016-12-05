module Figaro
  class Variable
    attr_reader :config, :name, :options, :key

    def initialize(config, name, options)
      @config, @name, @options = config, name, options
      @key = options.fetch(:key) { default_key }
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
      load(config.get(key) { self.value = default })
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

    def valid?
      required? ? value? : true
    end

    private

    def default_key
      name.to_s.upcase
    end
  end
end
