require "shellwords"
require "figaro/env"
require "figaro/railtie"
require "figaro/tasks"

module Figaro
  def self.env
    Figaro::ENV
  end
end
