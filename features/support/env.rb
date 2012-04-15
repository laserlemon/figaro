ROOT = File.expand_path("../../..", __FILE__)

puts "Travis ENV test: #{ENV["TRAVIS_ENV_TEST"].inspect}"
