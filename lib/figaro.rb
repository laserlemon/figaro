require "figaro/railtie"

module Figaro
  extend self

  def env
    flatten(raw).merge(raw.fetch(environment, {}))
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
    @environment || Rails.env
  end

  def environment=(other_env)
    @environment = other_env
  end

  private

  def flatten(hash)
    hash.reject{|_,v| Hash === v }
  end
end
