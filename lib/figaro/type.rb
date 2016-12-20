require "figaro/dsl"

module Figaro
  class Type
    def self.register(type_class)
      if defined? type_class::NAME
        type_name = type_class::NAME
        registered[type_name] = type_class
        Figaro::DSL.type(type_name, type_class)
      end
    end

    def self.registered
      @registered ||= {}
    end

    def self.load(name_or_class, type_options = {})
      type_class = registered.fetch(name_or_class) { name_or_class }

      if type_class.respond_to?(:load) && type_class.respond_to?(:dump)
        type_class
      elsif type_class.respond_to?(:new)
        case type_class.method(:new).arity
        when 0 then type_class.new
        when -2, -1, 1 then type_class.new(type_options)
        end
      end
    end

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def load(value)
      raise ::NotImplementedError
    end

    def dump(value)
      raise ::NotImplementedError
    end
  end
end
