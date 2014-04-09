module Figaro
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "figaro.load", before: :load_environment_config do
        Figaro.adapter = Figaro::Rails::Application
        Figaro.load
      end
    end
  end
end
