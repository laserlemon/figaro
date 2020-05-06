# frozen_string_literal: true

require "figaro/variable"

module Figaro
  class DSL
    def self.register_type(type_name, type_class)
      define_method(type_name) do |name, **options|
        variable(name, type_class, **options)
      end
    end

    attr_reader :config

    def initialize(config)
      @config = config
    end

    def environment(*)
      # TODO
    end

    def defaults(path)
      config.load_defaults(path)
    end

    def variable(name, type_class, **options)
      variable =
        Figaro::Variable.new(
          config: config,
          name: name,
          type_class: type_class,
          **options
        )
      config << variable
    end
  end
end
