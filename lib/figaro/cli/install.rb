require "figaro"

module Figaro
  class CLI < Thor
    class Install < Thor::Group
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

      include Thor::Actions

      attr_reader :variables, :environment_options

      def self.source_root
        File.expand_path("../install", __FILE__)
      end

      def load_variables
        @variables = args.map { |a| Variable.new(a) }
      end

      def variable_names_must_be_simple
        names = variables.map(&:name).uniq
        complex_names = names.reject { |n| n.to_sym.inspect == ":#{n}" }

        return if complex_names.none?

        raise ComplexVariableNames, complex_names
      end

      def variable_types_must_be_valid
        types = variables.map(&:type).uniq
        valid_types = Figaro::Type.registered.keys.map(&:to_s).sort
        invalid_types = (types - valid_types).sort

        return if invalid_types.none?

        raise InvalidVariableTypes, valid_types, invalid_types
      end

      def variable_names_must_be_unique
        duplicate_names = variables
          .group_by(&:name)
          .select { |_name, group| group.count > 1 }
          .keys

        return if duplicate_names.none?

        raise DuplicateVariableNames, duplicate_names
      end

      def infer_environment_options
        keys = defined?(Rack) ? ["RACK_ENV"] : []
        keys.unshift(defined?(Rails) ? "RAILS_ENV" : "APP_ENV")
        options = keys.count > 1 ? { keys: keys } : { key: keys.first }
        options[:default] = "development"
        @environment_options = options
      end

      def create_env_rb
        template("env.rb.tt", "env.rb")
      end

      def create_env_yml
        template("env.yml.tt", options[:path])
      end

      def ignore_configuration
        append_to_file(".gitignore", <<-EOF)

# Ignore Figaro's local configuration file
/#{options[:path]}
EOF
      end
    end
  end
end
