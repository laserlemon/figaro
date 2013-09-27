begin
  require "rails"
rescue LoadError
end

if defined?(::Rails)
  require "figaro/rails/application"
  require "figaro/rails/railtie"
end
