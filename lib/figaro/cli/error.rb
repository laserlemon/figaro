# frozen_string_literal: true

module Figaro
  class CLI < ::Thor
    class Error < ::Thor::MalformattedArgumentError
    end

    class ComplexVariableNamesError < Figaro::CLI::Error
      def initialize(complex_names:)
        message = Figaro::Utils.strip_heredoc(<<-ERR)
          ERROR:
            Variable names must be simple. Use letters and underscores only.
            Given:
          ERR
        complex_names.each { |name| message << "    #{name}\n" }

        super(message)
      end
    end

    class InvalidVariableTypesError < Figaro::CLI::Error
      def initialize(valid_types:, invalid_types:)
        message = Figaro::Utils.strip_heredoc(<<-ERR)
          ERROR:
            Variable types must be valid. Valid types are:
          ERR
        valid_types.each { |type| message << "    #{type}\n" }
        message << "  Given:\n"
        invalid_types.each { |type| message << "    #{type}\n" }

        super(message)
      end
    end

    class DuplicateVariableNamesError < Figaro::CLI::Error
      def initialize(duplicate_names:)
        message = Figaro::Utils.strip_heredoc(<<-ERR)
          ERROR:
            Variables names must be unique. Duplicate variable names were found.
            Found:
          ERR
        duplicate_names.each { |name| message << "    #{name}\n" }

        super(message)
      end
    end
  end
end
