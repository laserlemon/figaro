begin
  require "rails"
rescue LoadError
end

if defined?(::Rails)
  require "figaro/rails/railtie"
end
