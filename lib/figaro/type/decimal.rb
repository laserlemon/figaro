# frozen_string_literal: true

require "bigdecimal"

require "figaro/type"

module Figaro
  class Type
    class Decimal < Figaro::Type
      def load(value)
        case value
        when nil then nil
        when /\A\-?\d+(\.\d+)\z/ then BigDecimal(value)
        else raise_type_load_error(value)
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

Figaro::Type.register(:decimal, Figaro::Type::Decimal)
