# frozen_string_literal: true

require_relative "../type"

module Figaro
  class Type
    class Array < Figaro::Type
      def load(value)
        case value
        when nil then nil
        when ::String then value.split(separator).map { |e| type.load(e) }
        else raise_type_load_error(value)
        end
      end

      def dump(value)
        case value
        when nil then nil
        when ::Array then value.map { |e| type.dump(e) }.join(separator)
        else value.to_s
        end
      end

      private

      def separator
        @separator ||= options.fetch(:separator, ",")
      end

      def type
        @type ||= Figaro::Type.load(
          options.fetch(:type, :string),
          **options.fetch(:type_options, {})
        )
      end
    end
  end
end

Figaro::Type.register(:array, Figaro::Type::Array)
