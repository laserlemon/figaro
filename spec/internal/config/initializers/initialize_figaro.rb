require 'figaro'

Figaro.application = Figaro::Application.new(
  environment: ::Rails.env,
  path: File.expand_path('../application.yml', File.dirname(__FILE__))
)
Figaro.load
