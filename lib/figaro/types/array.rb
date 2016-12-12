require "figaro/type"

module Figaro
  module Types
    class Array < Figaro::Type
      NAME = :array

      def load(value)
        case value
        when nil then nil
        when ::String then value.split(separator)
        when ::Array then value
        else raise
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

Figaro::Type.register(Figaro::Types::Array)
