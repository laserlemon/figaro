# frozen_string_literal: true

require "bundler"
Bundler.setup

require "simplecov"
SimpleCov.start

require "figaro"

Bundler.require(:test)

Dir[File.expand_path("support/*.rb", __dir__)].each { |f| require f }
