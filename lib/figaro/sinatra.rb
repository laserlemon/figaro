begin
  require 'sinatra'
rescue LoadError
else
  require 'figaro'
  require 'figaro/sinatra/sinatra_app'
  Figaro.adapter = Figaro::SinatraApp
  Figaro.load
end
