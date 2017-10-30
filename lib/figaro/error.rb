require "thor/error"

module Figaro
  class Error < ::StandardError
  end

  class ComplexVariableNames < ::Thor::MalformattedArgumentError
    def initialize(complex_names)
      message = <<-ERR
ERROR:
  Variable names must be simple. Use letters and underscores only.
  Given:
ERR
      complex_names.each { |name| message << "    #{name}\n" }

      super(message)
    end
  end

  class InvalidVariableTypes < ::Thor::MalformattedArgumentError
    def initialize(valid_types, invalid_types)
      message <<-ERR
ERROR:
  Variable types must be valid. Valid types are:
ERR
      valid_types.each { |type| message << "    #{type}\n" }
      message << "  Given:\n"
      invalid_types.each { |type| message << "    #{type}\n" }

      super(message)
    end
  end

  class DuplicateVariableNames < ::Thor::MalformattedArgumentError
    def initialize(duplicate_names)
      message = <<-ERR
ERROR:
  Variables names must be unique. Duplicate variable names were found.
  Found:
ERR
      duplicate_names.each { |name| message << "    #{name}\n" }

      super(message)
    end
  end
end
