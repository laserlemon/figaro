module Figaro
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def create_configuration_file
        copy_file "application.yml", "config/application.yml"
      end
    end
  end
end
