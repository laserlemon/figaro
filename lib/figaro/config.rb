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
    ENVFILE_PATH = "env.rb".freeze
    ENVFILE_PATH_KEY = "FIGARO_ENVFILE".freeze

    def self.load
      new.tap(&:load)
    end

    def self.find_envfile_path
      Figaro::Utils.find_file_path(default_envfile_path)
    end

    def self.default_envfile_path
      ::Pathname.new(ENV[ENVFILE_PATH_KEY] || ENVFILE_PATH)
    end

    attr_reader :defaults, :variables

    def initialize
      @dsl = Figaro::DSL.new(self)
      @envfile_path = self.class.find_envfile_path
      @envfile_content = @envfile_path.read
      @defaults = {}
      @variables = []
      @accessors = ::Module.new

      extend @accessors
    end

    def load
      @dsl.instance_eval(@envfile_content, @envfile_path.to_s, 1)
      validate!
    end

    def load_defaults(path)
      defaults = ::YAML.load_file(path) || {}
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
      add_accessors(variable)
    end

    def get(key, &default)
      ENV.fetch(key, &default)
    end

    def set(key, value)
      ENV[key] = value
    end

    def evaluate(option)
      if option.respond_to?(:to_proc) && !option.is_a?(::Hash)
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

    def add_accessors(variable)
      @accessors.instance_eval do
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
