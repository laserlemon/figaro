module Figaro
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      Figaro.configure
    end

    rake_tasks do
      load "figaro/tasks.rake"
    end
  end
end
