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

        message = <<-ERR
ERROR:
  Variable names must be simple. Use letters and underscores only.
  Given:
ERR
        complex_names.each { |n| message << "    #{n}\n" }
        raise Thor::MalformattedArgumentError, message
      end

      def variable_types_must_be_valid
        types = variables.map(&:type).uniq
        valid_types = Figaro::Type.registered.keys.map(&:to_s).sort
        invalid_types = (types - valid_types).sort

        return if invalid_types.none?

        message = <<-ERR
ERROR:
  Variable types must be valid. Valid types are:
ERR
        valid_types.each { |t| message << "    #{t}\n" }
        message << "  Given:\n"
        invalid_types.each { |t| message << "    #{t}\n" }
        raise Thor::MalformattedArgumentError, message
      end

      def variables_must_be_unique
        variable_types_by_name = {}
        new_variables = []
        ignored_variables = []
        duplicate_variables = []

        variables.each do |variable|
          existing_variable_type = variable_types_by_name[variable.name]

          if existing_variable_type && variable.type == existing_variable_type
            ignored_variables << variable
          elsif existing_variable_type
            duplicate_variables << variable
          else
            variable_types_by_name[variable.name] = variable.type
            new_variables << variable
          end
        end

        if ignored_variables.any?
          message = <<-WRN
WARNING:
  Duplicate variables were found and ignored.
  Ignored:
WRN
          ignored_variables.each { |v| message << "    #{v}\n" }
          warn message
        end

        if duplicate_variables.any?
          message = <<-ERR
ERROR:
  Variables must be unique. Duplicate variable names were found.
  Found:
ERR
          duplicate_variables.each { |v| message << "    #{v}\n" }
          raise Thor::MalformattedArgumentError, message
        end

        variables.replace(new_variables)
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
