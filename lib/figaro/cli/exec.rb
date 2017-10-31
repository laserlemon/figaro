require "figaro"

module Figaro
  class CLI < ::Thor
    class Exec < Figaro::CLI::Command
      def invoke
        validate_command
        load_configuration
        execute_command
      end

      private

      def validate_command
        return if command
        warn "figaro: exec needs a command to run"
        exit 128
      end

      def load_configuration
        Figaro.load
      end

      def execute_command
        Kernel.exec(*args)
      rescue Errno::EACCES, Errno::ENOEXEC
        warn "figaro: not executable: #{command}"
        exit 126
      rescue Errno::ENOENT
        warn "figaro: command not found: #{command}"
        exit 127
      end

      def command
        @command ||= args.first
      end
    end
  end
end
