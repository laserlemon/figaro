require "figaro/type"

module Figaro
  class Variable
    attr_reader :config, :name, :key, :type

    def initialize(config, name, type_class, options)
      @config, @name = config, name.to_sym

      options = options.dup
      @key = options.delete(:key) { default_key }
      @default = config.defaults.fetch(name.to_s, options.delete(:default))
      @required = options.delete(:required) { true }

      @type = Figaro::Type.load(type_class, options)
    end

    def value
      type.load(config.get(key) { set_and_get_default_value })
    end

    def value=(value)
      config.set(key, type.dump(value))
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

    # TODO: Allow a custom validation to be provided via options.
    def valid?
      required? ? !value.nil? : true
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
