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
        if File.exists?(".spring.rb")
          spring_file = "spring.rb"
        elsif File.exists?("config/spring.rb")
          spring_file = "config/spring.rb"          
        else
          spring_file = "config/spring.rb"          
          create_file(spring_file)
        end
        
        append_to_file spring_file, 'Spring.watch "config/application.yml"' 
      end
      
    end
  end
end
