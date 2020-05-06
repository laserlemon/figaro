# frozen_string_literal: true

require_relative "lib/figaro/version"

Gem::Specification.new do |spec|
  spec.name = "figaro"
  spec.version = Figaro.version

  spec.author = "Steve Richert"
  spec.email = "steve.richert@gmail.com"

  spec.summary = "Simple Ruby app configuration"
  spec.description = "Figaro is a simple library for configuring twelve-factor Ruby applications."
  spec.homepage = "https://github.com/laserlemon/figaro"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").grep_v(/\A(Gemfile|Rakefile|bin|spec)/)
  spec.bindir = "exe"
  spec.executables = spec.files.grep(/\Aexe/) { |f| File.basename(f) }

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_dependency "thor", ">= 0.14.0", "< 2"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
