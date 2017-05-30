require "figaro/type"

module Figaro
  class Type
    class String < Figaro::Type
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

Figaro::Type.register(:string, Figaro::Type::String)
