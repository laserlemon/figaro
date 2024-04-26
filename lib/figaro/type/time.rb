# frozen_string_literal: true

require "time"

require_relative "../type"

module Figaro
  class Type
    class Time < Figaro::Type
      def load(value)
        case value
        when nil then nil
        when ::String
          ::Time.strptime(value, format)
        else raise_type_load_error(value)
        end
      end

      def dump(value)
        case value
        when nil then nil
        when ::Time then value.strftime(format)
        else value.to_s
        end
      end

      private

      def format
        @format ||= options.fetch(:format, "%FT%T%:z")
      end
    end
  end
end

Figaro::Type.register(:time, Figaro::Type::Time)
