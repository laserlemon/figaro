module Figaro
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      class_option :spring, type: :boolean, default: false
      
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
        spring_config = File.exists?("config/spring.rb")
        if options.spring? || spring_config
          create_file("config/spring.rb") unless spring_config
          append_to_file "config/spring.rb", 'Spring.watch "config/application.yml"' 
          system('touch config/application.rb') # causes spring to load the changes we introduced above.
        end
      end
      
    end
  end
end
