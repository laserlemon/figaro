require "figaro/application"
require "figaro/env"
require "figaro/railtie"
require "figaro/tasks"

module Figaro
  extend self

  attr_writer :application

  def env
    Figaro::ENV
  end

  def application
    @application ||= Figaro::Application.new
  end

  def load
    application.load
  end
end
