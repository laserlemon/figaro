require "figaro/variable"

module Figaro
  module Types
    class Array < Figaro::Variable
      def load(value)
        case value
        when nil then nil
        when ::Array then value
        else value.split(separator)
        end
      end

      def dump(value)
        case value
        when nil then nil
        when ::Array then value.join(separator)
        else value.to_s
        end
      end

      private

      def separator
        options.fetch(:separator, ",")
      end
    end
  end
end
