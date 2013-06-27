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
    Figaro::Env.from(stringify(flatten(raw).merge(raw.fetch(environment, {}))))
  end

  def raw
    @raw ||= yaml && YAML.load(yaml) || {}
  end

  def yaml
    @yaml ||= File.exist?(path) ? ERB.new(File.read(path)).result : nil
  end

  def path
    @path ||= Rails.root.join("config", "application.yml")
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
