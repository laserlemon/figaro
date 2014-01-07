# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name    = "figaro-oma"
  gem.version = "0.6.7777777"

  gem.authors     = ["Steve Richert"]
  gem.email       = ["steve.richert@gmail.com"]
  gem.summary     = "Simple Rails app configuration"
  gem.description = "Simple, Heroku-friendly Rails app configuration using ENV and a single YAML file"
  gem.homepage    = "https://github.com/laserlemon/figaro"
  gem.license     = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(/^(features|spec)/)
  gem.require_paths = ["lib"]


  gem.add_dependency("bundler","~> 1.0")

  gem.add_development_dependency("rspec")

end
