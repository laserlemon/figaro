require "figaro/type"

module Figaro
  class Type::Integer < Figaro::Type
    NAME = :integer

    def load(value)
      case value
      when nil then nil
      when /\A\-?\d+\z/ then Integer(value)
      when ::Integer then value
      else raise
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

Figaro::Type.register(Figaro::Type::Integer)
