lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "figaro/version"

Gem::Specification.new do |spec|
  spec.name    = "figaro"
  spec.version = Figaro::VERSION

  spec.author = "Steve Richert"
  spec.email  = "steve.richert@gmail.com"

  spec.summary     = "Simple Ruby app configuration"
  spec.description = "Figaro is a simple library for configuring twelve-factor Ruby applications."
  spec.homepage    = "https://github.com/laserlemon/figaro"
  spec.license     = "MIT"

  spec.files      = `git ls-files -z`.split("\x0")
  spec.test_files = spec.files.grep(/^spec/)

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 11.3"
end
