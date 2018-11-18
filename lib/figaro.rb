# frozen_string_literal: true

require "figaro/config"
require "figaro/utils"
require "figaro/version"

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
