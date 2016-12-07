require "figaro/types"

module Figaro
  class DSL
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def variable(name, type, options = {})
      type.new(config, name, options).tap { |variable| config << variable }
    end

    def string(name, options = {})
      variable(name, Figaro::Types::String, options)
    end

    def integer(name, options = {})
      variable(name, Figaro::Types::Integer, options)
    end

    def decimal(name, options = {})
      variable(name, Figaro::Types::Decimal, options)
    end

    def boolean(name, options = {})
      variable(name, Figaro::Types::Boolean, options)
    end

    def array(name, options = {})
      variable(name, Figaro::Types::Array, options)
    end
  end
end
