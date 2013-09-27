module Figaro
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_configuration do
        Figaro.load
      end

      rake_tasks do
        load "figaro/rails/tasks.rake"
      end
    end
  end
end
