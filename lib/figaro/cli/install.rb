# frozen_string_literal: true

require "figaro"

module Figaro
  class CLI < ::Thor
    class Install < ::Thor::Group
      class Variable
        attr_reader :name, :type

        def initialize(string)
          name, type = string.downcase.split(":", 2)
          @name = name
          @type = type || "string"
        end

        def to_s
          "#{name}:#{type}"
        end
      end

      include ::Thor::Actions

      source_root ::File.expand_path("install", __dir__)

      attr_reader :variables, :environment_options

      def load_variables
        @variables = args.map { |a| Figaro::CLI::Install::Variable.new(a) }
      end

      def variable_names_must_be_simple
        names = variables.map(&:name).uniq
        complex_names = names.reject { |n| n.to_sym.inspect == ":#{n}" }

        return if complex_names.none?

        raise Figaro::CLI::ComplexVariableNamesError,
          complex_names:
      end

      def variable_types_must_be_valid
        types = variables.map(&:type).uniq
        valid_types = Figaro::Type.registered.keys.map(&:to_s).sort
        invalid_types = (types - valid_types).sort

        return if invalid_types.none?

        raise Figaro::CLI::InvalidVariableTypesError,
          valid_types:, invalid_types:
      end

      def variable_names_must_be_unique
        duplicate_names = variables
          .group_by(&:name)
          .select { |_name, group| group.count > 1 }
          .keys

        return if duplicate_names.none?

        raise Figaro::CLI::DuplicateVariableNamesError,
          duplicate_names:
      end

      def infer_environment_options
        keys = using_rack? ? ["RACK_ENV"] : []
        keys.unshift(using_rails? ? "RAILS_ENV" : "APP_ENV")
        options = keys.count > 1 ? { keys: } : { key: keys.first }
        options[:default] = "development"
        @environment_options = options
      end

      def create_envfile
        template("env.rb.tt", "env.rb")
      end

      def create_local_configuration_file
        template("env.yml.tt", options[:path])
      end

      def git_ignore_local_configuration_file
        append_to_file(".gitignore", <<~STR)

          # Ignore Figaro's local configuration file
          /#{options[:path]}
          STR
      end

      private

      def using_rails?
        return @using_rails if defined? @using_rails

        @using_rails = bundled_gems.include?("rails") ||
          ::File.exist?("bin/rails")
      end

      def using_rack?
        return @using_rack if defined? @using_rack

        @using_rack = using_rails? || bundled_gems.include?("rack")
      end

      def bundled_gems
        return [] unless defined?(::Bundler) && defined?(::Bundler::Error)
        return @bundled_gems if defined? @bundled_gems

        @bundled_gems = ::Bundler.locked_gems&.specs&.map(&:name) || []
      rescue Bundler::BundlerError
        []
      end
    end
  end
end
