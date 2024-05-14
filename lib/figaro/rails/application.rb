module Figaro
  module Rails
    class Application < Figaro::Application
      private

      def default_path
        rails_not_initialized! unless ::Rails.root

        if ::ENV["FIGARO_PATH"]
          ::Rails.root.join(::ENV["FIGARO_PATH"])
        else
          ::Rails.root.join("config", "application.yml")
        end
      end

      def default_environment
        ::Rails.env
      end

      def rails_not_initialized!
        raise RailsNotInitialized
      end
    end
  end
end
