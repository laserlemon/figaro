require "pathname"
require "yaml"

require "figaro/dsl"
require "figaro/error"
require "figaro/types"

module Figaro
  class Config
    ENVFILE = "Envfile"

    def self.load(envfile_path = find_envfile)
      new(envfile_path).tap(&:load)
    end

    def self.find_envfile
      path = ENV["FIGARO_ENVFILE"]
      return path if path && !path.empty?

      previous, current = nil, File.expand_path(::Pathname.pwd)

      until !::File.directory?(current) || current == previous
        path = ::File.join(current, ENVFILE)
        return path if ::File.file?(path)

        previous, current = current, ::File.expand_path("..", current)
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
      defaults = ::YAML.load_file(path) || {}
    # TODO: Inform the developer that defaults could not be loaded.
    rescue ::SystemCallError
      defaults = {}
    # TODO: Rescue other common error cases and provide helpful messaging.
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
      option.respond_to?(:to_proc) ? instance_exec(&option) : option
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
