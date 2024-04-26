# frozen_string_literal: true

module Figaro
  class Type
    def self.register(type_name, type_class)
      registered[type_name] = type_class
      Figaro::DSL.register_type(type_name, type_class)
    end

    def self.registered
      @registered ||= {}
    end

    def self.load(name_or_class, **options)
      type_class = registered.fetch(name_or_class) { name_or_class }

      if type_class.respond_to?(:load) && type_class.respond_to?(:dump)
        type_class
      elsif type_class.respond_to?(:new)
        type_class.new(**options)
      end
    end

    attr_reader :options

    def initialize(**options)
      @options = options
    end

    def load(_value)
      raise ::NotImplementedError
    end

    def dump(_value)
      raise ::NotImplementedError
    end

    private

    def raise_type_load_error(value)
      raise Figaro::TypeLoadError, type: self, value:
    end
  end
end
