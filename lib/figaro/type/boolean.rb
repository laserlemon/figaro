require "figaro/type"

module Figaro
  class Type::Boolean < Figaro::Type
    NAME = :boolean

    def load(value)
      case value
      when nil then nil
      when true, /\A(t(rue)?|y(es)?|on|1)\z/i then true
      when false, /\A(f(alse)?|n(o)?|off|0)\z/i then false
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

Figaro::Type.register(Figaro::Type::Boolean)
