require "date"

require "figaro/type"

module Figaro
  class Type::Date < Figaro::Type
    def load(value)
      case value
      when nil then nil
      when ::String then ::Date.strptime(value, format)
      else raise
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
      options.fetch(:format, "%F")
    end
  end
end

Figaro::Type.register(:date, Figaro::Type::Date)
