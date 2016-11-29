require "figaro/variable"

module Figaro
  module Types
    class Integer < Figaro::Variable
      def load(value)
        value.nil? ? nil : Integer(value)
      end
    end
  end
end
