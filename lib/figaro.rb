require "figaro/config"
require "figaro/utils"
require "figaro/version"

module Figaro
  def self.config
    ::Thread.current[:figaro_config] ||= Figaro::Config.load
  end
end
