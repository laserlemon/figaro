begin
  require "rails"
rescue LoadError
else
  require "figaro/rails/application"
  require "figaro/rails/railtie"

  Figaro.adapter = Figaro::Rails::Application
end
