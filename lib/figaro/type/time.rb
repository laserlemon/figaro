require "time"

require "figaro/type"

module Figaro
  class Type::Time < Figaro::Type
    def load(value)
      case value
      when nil then nil
      when ::String then ::Time.strptime(value, format)
      when ::Time then value
      else raise
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
      options.fetch(:format, "%FT%T%:z")
    end
  end
end

Figaro::Type.register(:time, Figaro::Type::Time)
