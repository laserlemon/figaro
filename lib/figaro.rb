require "shellwords"
require "figaro/env"
require "figaro/railtie"
require "figaro/tasks"

module Figaro
  extend self

  def vars(custom_environment = nil)
    env(custom_environment).map { |key, value|
      "#{key}=#{Shellwords.escape(value)}"
    }.sort.join(" ")
  end

  def env(custom_environment = nil)
    environment = (custom_environment || self.environment).to_s
    hash = flatten(raw).merge(raw.fetch(environment, {}))
    hash_local = flatten(raw(true)).merge(raw(true).fetch(environment, {}))
    Figaro::Env.from(stringify(hash.merge(hash_local)))
  end

  def raw(local = false)
    @raw ||= {}
    @raw[local] ||= yaml(local) && YAML.load(yaml(local)) || {}
  end

  def yaml(local = false)
    @yaml ||= {}
    @yaml[local] ||= File.exist?(path(local)) ? File.read(path(local)) : nil
  end

  def path(local = false)
    @path ||= {}
    file_name = local ? "application.local.yml" : "application.yml"
    @path[local] ||= Rails.root.join("config", file_name)
  end

  def environment
    Rails.env
  end

  private

  def flatten(hash)
    hash.reject { |_, v| Hash === v }
  end

  def stringify(hash)
    hash.inject({}) { |h, (k, v)| h[k.to_s] = v.nil? ? nil : v.to_s; h }
  end
end
