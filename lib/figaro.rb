require "figaro/env"
require "figaro/railtie"
require 'figaro/figaro_settings'

module Figaro
  extend self

  def vars
    env.map{|k,v| "#{k}=#{v}" }.sort.join(" ")
  end

  def env
    Figaro::Env.from(stringify(flatten(raw).merge(raw.fetch(environment, {}))))
  end

  def raw
    yaml && YAML.load(yaml) || {}
  end

  def yaml
    File.exist?(path) ? File.read(path) : nil
  end

  def path
    Rails.root.join("config/application.yml")
  end

  def environment
    Rails.env
  end

  private

  def flatten(hash)
    hash.reject{|_,v| Hash === v }
  end

  def stringify(hash)
    hash.inject({}){|h,(k,v)| h[k.to_s] = v.to_s; h }
  end
end
