require "figaro/application"
require "figaro/env"
require "figaro/rails"

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
end
