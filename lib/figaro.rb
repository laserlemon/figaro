require "figaro/application"
require "figaro/env"
require "figaro/rails"
require "figaro/tasks"

module Figaro
  extend self

  attr_writer :backend, :application

  def env
    Figaro::ENV
  end

  def backend
    @backend ||= Figaro::Rails::Application
  end

  def application
    @application ||= backend.new
  end

  def load
    application.load
  end
end
