require "figaro/dsl"

module Figaro
  class Type
    def self.register(type_class)
      if defined? type_class::NAME
        Figaro::DSL.type(type_class::NAME, type_class)
      end
    end

    def self.load(name_or_class)
      all.fetch(name_or_class) { name_or_class }
    end

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def load(value)
      raise NotImplementedError
    end

    def dump(value)
      raise NotImplementedError
    end
  end
end
