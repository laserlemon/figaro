# at require-time, we need Rails to be defined to initialize the railtie
# and set the default adapter to the Rails::Application adapter
if defined?(Rails)
  require "figaro/rails/application"
  require "figaro/rails/railtie"
  Figaro.adapter = Figaro::Rails::Application
end
