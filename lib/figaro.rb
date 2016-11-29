require "figaro/version"
require "figaro/config"

module Figaro
  def self.config
    Thread.current[:figaro_config] ||= Figaro::Config.load
  end
end
