module Figaro
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_configuration do
        Figaro.load
      end
    end
  end
end
