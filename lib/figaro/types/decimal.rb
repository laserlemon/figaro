require "bigdecimal"

require "figaro/variable"

module Figaro
  module Types
    class Decimal < Figaro::Variable
      def load(value)
        case value
        when nil then nil
        when BigDecimal then value
        when Float then BigDecimal(value.to_s)
        else BigDecimal(value)
        end
      end

      def dump(value)
        case value
        when nil then nil
        when BigDecimal then value.to_s("F")
        else value.to_s
        end
      end
    end
  end
end
