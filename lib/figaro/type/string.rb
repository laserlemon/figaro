# frozen_string_literal: true

require_relative "../type"

module Figaro
  class Type
    class String < Figaro::Type
      def load(value)
        case value
        when nil then nil
        when ::String then value
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

Figaro::Type.register(:string, Figaro::Type::String)
