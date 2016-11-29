require "figaro/variable"

module Figaro
  module Types
    class Boolean < Figaro::Variable
      def load(value)
        case value
        when true, /\A(t(rue)?|y(es)?|on|1)\z/i then true
        when false, /\A(f(alse)?|n(o)?|off|0)\z/i then false
        else nil
        end
      end
    end
  end
end
