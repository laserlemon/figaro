require "thor/group"

module Figaro
  class CLI < Thor
    class Install < Thor::Group
      include Thor::Actions

      class_option "path",
        aliases: ["-p"],
        default: "config/application.yml",
        desc: "Specify a configuration file path"

      def self.source_root
        File.expand_path("../install", __FILE__)
      end

      def create_configuration
        copy_file("application.yml", options[:path])
      end

      def ignore_configuration
        if File.exists?(".gitignore")
          append_to_file(".gitignore", <<-EOF)

# Ignore application configuration
/#{options[:path]}
EOF
        end
      end
    end
  end
end
