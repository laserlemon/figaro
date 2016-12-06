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
      load(config.get(key) { set_and_get_default_value })
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

    # Used in #value because using #value= returns the given argument, no matter
    # what the method returns. Within #value's config.get block, we need the
    # returned value to be the string value persisted to ENV. Otherwise, decimal
    # variables choke on float default values.
    def set_and_get_default_value
      self.value = default
      config.get(key) { nil }
    end
  end
end
