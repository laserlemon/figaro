require "pathname"

require "figaro/types/string"
require "figaro/types/integer"
require "figaro/types/decimal"
require "figaro/types/boolean"

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
      @envfile_path = Pathname.new(envfile_path).expand_path.to_s
      @envfile_content = File.read(@envfile_path)
      @variables = []
      @variable_methods = Module.new

      extend @variable_methods
    end

    def load
      instance_eval(@envfile_content, @envfile_path, 1)
    end

    def variable(name, type, options = {})
      type.new(self, name, options).tap do |variable|
        @variables << variable
        add_variable_methods(variable)
      end
    end

    def string(name, options = {})
      variable(name, Figaro::Types::String, options)
    end

    def integer(name, options = {})
      variable(name, Figaro::Types::Integer, options)
    end

    def decimal(name, options = {})
      variable(name, Figaro::Types::Decimal, options)
    end

    def boolean(name, options = {})
      variable(name, Figaro::Types::Boolean, options)
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
  end
end
