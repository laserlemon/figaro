require "figaro/error"
require "figaro/env"
require "figaro/env_array"
require "figaro/application"

module Figaro
  extend self

  attr_writer :adapter, :application

  def env
    Figaro::ENV
  end

  def env_start_with
    Figaro::ENVArray::StartWith
  end

  def env_end_with
    Figaro::ENVArray::EndWith
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

  def require_keys(*keys)
    missing_keys = keys.flatten - ::ENV.keys
    raise MissingKeys.new(missing_keys) if missing_keys.any?
  end
end

require "figaro/rails"
