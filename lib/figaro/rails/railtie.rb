module Figaro
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "figaro.load", before: :load_environment_config do
        Figaro.load
      end

      rake_tasks do
        load "figaro/rails/tasks.rake"
      end
    end
  end
end
