module Figaro
  class CLI < Thor
    class Command
      attr_reader :args, :options

      def self.invoke(args, options)
        new(args, options).invoke
      end

      def initialize(args, options)
        @args = args
        @options = options
      end

      def invoke
        raise NotImplementedError
      end
    end
  end
end
