module Figaro
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end

      def copy_files
        template "application.yml", "config/application.yml"
      end
    end
  end
end
