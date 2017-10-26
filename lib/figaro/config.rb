require "pathname"
require "yaml"

require "figaro/dsl"
require "figaro/error"
require "figaro/type/array"
require "figaro/type/boolean"
require "figaro/type/date"
require "figaro/type/decimal"
require "figaro/type/integer"
require "figaro/type/string"
require "figaro/type/time"

module Figaro
  class Config
    ENVFILE = "Envfile".freeze

    def self.load(envfile_path = find_envfile)
      new(envfile_path).tap(&:load)
    end

    def self.find_envfile
      path = ENV["FIGARO_ENVFILE"]
      return path if path && !path.empty?

      previous = nil
      current = File.expand_path(::Pathname.pwd)

      until !::File.directory?(current) || current == previous
        path = ::File.join(current, ENVFILE)
        return path if ::File.file?(path)

        previous = current
        current = ::File.expand_path("..", current)
      end
    end

    attr_reader :defaults, :variables

    def initialize(envfile_path)
      @dsl = Figaro::DSL.new(self)
      @envfile_path = ::Pathname.new(envfile_path).expand_path.to_s
      @envfile_content = ::File.read(@envfile_path)
      @defaults = {}
      @variables = []
      @variable_methods = ::Module.new

      extend @variable_methods
    end

    def load
      @dsl.instance_eval(@envfile_content, @envfile_path, 1)
      validate!
    end

    def load_defaults(path)
      defaults = ::YAML.load_file(path)
      # TODO: Validate the loaded defaults to verify the returned value is a
      # hash with a single level of nesting and string keys.
    rescue # rubocop:disable Lint/HandleExceptions, Lint/RescueWithoutErrorClass
      # TODO: Tell the developer why defaults could not be loaded. This might
      # happen if no file exists at the given path or a file exists but is not
      # valid YAML. Invalid YAML should raise an exception. A missing file
      # should be an acceptable case because a developer may depend on the
      # presence of defaults locally but those defaults may not be present on
      # the server.
    else
      @defaults.update(defaults)
    end

    def <<(variable)
      @variables << variable
      add_variable_methods(variable)
    end

    def get(key, &default)
      ENV.fetch(key, &default)
    end

    def set(key, value)
      ENV[key] = value
    end

    def evaluate(option)
      if option.respond_to?(:to_proc) && !option.is_a?(Hash)
        instance_exec(&option)
      else
        option
      end
    end

    def to_h
      variables.each_with_object({}) do |variable, hash|
        hash[variable.name] = variable.value
      end
    end

    private

    def add_variable_methods(variable)
      @variable_methods.instance_eval do
        define_method(variable.name, &variable.method(:value))
        define_method(:"#{variable.name}=", &variable.method(:value=))
        define_method(:"#{variable.name}?", &variable.method(:value?))
      end
    end

    # TODO: Use a specific Figaro::Error subclass with better messaging.
    def validate!
      raise Figaro::Error unless @variables.all?(&:valid?)
    end
  end
end
