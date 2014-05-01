require "figaro/application"

module Figaro
  class CLI < Thor
    class Task
      attr_reader :options

      def self.run(options = {})
        new(options).run
      end

      def initialize(options = {})
        @options = options
      end

      private

      def configuration
        application.configuration
      end

      def application
        @application ||= Figaro::Application.new(options)
      end

      if defined? Bundler
        def system(*)
          Bundler.with_clean_env { super }
        end
      end
    end
  end
end
