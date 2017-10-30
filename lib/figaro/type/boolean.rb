require "figaro/type"

module Figaro
  class Type
    class Boolean < Figaro::Type
      def load(value)
        case value
        when nil then nil
        when /\A(t(rue)?|y(es)?|on|1)\z/i then true
        when /\A(f(alse)?|n(o)?|off|0)\z/i then false
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

Figaro::Type.register(:boolean, Figaro::Type::Boolean)
