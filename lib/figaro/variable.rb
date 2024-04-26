# frozen_string_literal: true

require_relative "type"

module Figaro
  class Variable
    attr_reader :config, :name, :type, :key

    def initialize(
      config:,
      name:,
      type_class:,
      key: nil,
      default: nil,
      required: true,
      **options
    )
      @config = config
      @name = name.to_s
      @type = Figaro::Type.load(type_class, **options)
      @key = key || @name.upcase
      @default = @config.defaults.fetch(@name, default)
      @required = required
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
