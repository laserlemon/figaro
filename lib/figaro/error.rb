# frozen_string_literal: true

module Figaro
  class Error < ::StandardError
  end

  class TypeLoadError < Figaro::Error
    def initialize(type:, value:)
      message = Figaro::Utils.squish(<<-ERR)
        The value #{value.inspect} cannot be loaded by a variable of type of
        type #{type.class.name}.
        ERR

      super(message)
    end
  end
end
