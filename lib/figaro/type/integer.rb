require "figaro/type"

module Figaro
  class Type
    class Integer < Figaro::Type
      def load(value)
        case value
        when nil then nil
        when /\A\-?\d+\z/ then Integer(value)
        else raise_type_load_error(value)
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

Figaro::Type.register(:integer, Figaro::Type::Integer)
