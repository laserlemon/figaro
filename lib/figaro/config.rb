require "pathname"

require "figaro/types"
require "figaro/error"

module Figaro
  class Config
    ENVFILE = "Envfile"

    def self.load(envfile_path = find_envfile)
      new(envfile_path).tap(&:load)
    end

    def self.find_envfile
      path = ENV["FIGARO_ENVFILE"]
      return path if path && !path.empty?

      previous, current = nil, File.expand_path(Pathname.pwd)

      until !File.directory?(current) || current == previous
        path = File.join(current, ENVFILE)
        return path if File.file?(path)

        previous, current = current, File.expand_path("..", current)
      end
    end

    def initialize(envfile_path)
      @dsl = Figaro::DSL.new(self)
      @envfile_path = Pathname.new(envfile_path).expand_path.to_s
      @envfile_content = File.read(@envfile_path)
      @variables = []
      @variable_methods = Module.new

      extend @variable_methods
    end

    def load
      @dsl.instance_eval(@envfile_content, @envfile_path, 1)
      validate!
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

    private

    def add_variable_methods(variable)
      @variable_methods.instance_eval do
        define_method(variable.name, &variable.method(:value))
        define_method(:"#{variable.name}=", &variable.method(:value=))
        define_method(:"#{variable.name}?", &variable.method(:value?))
      end
    end

    def validate!
      raise Figaro::Error unless @variables.all?(&:valid?)
    end
  end
end
