require "figaro/error"
require "figaro/env"
require "figaro/application"

module Figaro
  extend self

  attr_writer :adapter, :application

  def env
    Figaro::ENV
  end

  def adapter
    @adapter ||= Figaro::Application
  end

  def application
    @application ||= adapter.new
  end

  def load
    application.load
  end

  def require(*required)
    if required.first.respond_to?(:keys)
      missing = required.first.reject{ |k,v| ::ENV.keys.include?(k.to_s) }
    else
      missing = required.flatten - ::ENV.keys
    end

    raise MissingKeys.new(missing) if missing.any?
  end
end

require "figaro/rails"
