require "bigdecimal"

require "figaro/type"

module Figaro
  module Types
    class Decimal < Figaro::Type
      NAME = :decimal

      def load(value)
        case value
        when nil then nil
        when /\A\-?\d+(\.\d+)\z/ then BigDecimal(value)
        when ::Float then BigDecimal(value.to_s)
        when ::BigDecimal then value
        else raise
        end
      end

      def dump(value)
        case value
        when nil then nil
        when ::BigDecimal then value.to_s("F")
        else value.to_s
        end
      end
    end
  end
end

Figaro::Type.register(Figaro::Types::Decimal)
