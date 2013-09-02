require "shellwords"
require "figaro/env"
if defined?(RAILS)
require "figaro/railtie"
end
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
    @yaml ||= File.exist?(path) ? File.read(path) : nil
  end

  def path
    @path ||= File.join(root,"config", "application.yml")
  end

  def environment
     ENV["RAILS_ENV"] || ENV["RACK_ENV"]
  end

  def root
    Dir.pwd
  end

  def load!
     ENV.update(env)
  end

  private

  def flatten(hash)
    hash.reject { |_, v| Hash === v }
  end

  def stringify(hash)
    hash.inject({}) { |h, (k, v)| h[k.to_s] = v.nil? ? nil : v.to_s; h }
  end
end
