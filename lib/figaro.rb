# frozen_string_literal: true

require_relative "figaro/config"
require_relative "figaro/utils"
require_relative "figaro/version"

module Figaro
  def self.config
    ::Thread.current[:figaro_config] ||= Figaro::Config.load
  end

  def self.load
    config
    true
  end

  def self.loaded?
    !!::Thread.current[:figaro_config]
  end

  def self.reload
    ::Thread.current[:figaro_config] = Figaro::Config.load
  end
end
