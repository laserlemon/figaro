module Figaro
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def create_configuration
        copy_file("application.yml", "config/application.yml")
      end

      def ignore_configuration
        if File.exists?(".gitignore")
          append_to_file(".gitignore") do
            <<-EOF.strip_heredoc

            # Ignore application configuration
            /config/application.yml
            EOF
          end
        end
      end
      
      def spring_configuration
        create_file("config/spring.rb") unless File.exists?("config/spring.rb")
        append_to_file "config/spring.rb", 'Spring.watch "config/application.yml"' 
      end
      
    end
  end
end
