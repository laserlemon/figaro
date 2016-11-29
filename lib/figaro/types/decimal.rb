require "bigdecimal"

require "figaro/variable"

module Figaro
  module Types
    class Decimal < Figaro::Variable
      def load(value)
        value.nil? ? nil : BigDecimal(value)
      end
    end
  end
end
