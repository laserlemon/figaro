require "figaro/type"

module Figaro
  module Types
    class String < Figaro::Type
      NAME = :string

      def load(value)
        case value
        when nil then nil
        when ::String then value
        else raise
        end
      end

      def dump(value)
        case value
        when nil then nil
        else value.to_s
        end
      end
    end
  end
end

Figaro::Type.register(Figaro::Types::String)
