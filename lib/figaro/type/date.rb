require "date"

require "figaro/type"

module Figaro
  class Type
    class Date < Figaro::Type
      def load(value)
        case value
        when nil then nil
        when ::String then ::Date.strptime(value, format)
        else raise_type_load_error(value)
        end
      end

      def dump(value)
        case value
        when nil then nil
        when ::Date then value.strftime(format)
        else value.to_s
        end
      end

      private

      def format
        @format ||= options.fetch(:format, "%F")
      end
    end
  end
end

Figaro::Type.register(:date, Figaro::Type::Date)
