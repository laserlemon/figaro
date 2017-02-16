require 'figaro'

Figaro.application = Figaro::Application.new(
  environment: ::Rails.env,
  path: File.expand_path('../application.yml', __dir__)
)
Figaro.load
