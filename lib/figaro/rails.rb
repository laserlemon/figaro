begin
  require "rails"
rescue LoadError
else
  require "figaro/rails/application"
  Figaro.adapter = Figaro::Rails::Application
  require "figaro/rails/railtie"
end
