require "thor"

require "figaro/cli/heroku_set"
require "figaro/cli/installer"

module Figaro
  class CLI < Thor
    desc "heroku:set", "Send Figaro configuration to Heroku"

    method_option "app",
      aliases: ["-a"],
      desc: "Specify a Heroku app"
    method_option "environment",
      aliases: ["-e"],
      desc: "Specify an application environment"
    method_option "path",
      aliases: ["-p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"

    define_method "heroku:set" do
      HerokuSet.run(options)
    end


    desc "install", "Installs Figaro into your app"

    method_option "spring",
      aliases: ["--spring"],
      desc: "Configurs Figaro files for Spring.  Creates a config/spring.rb file if there isn't one present."
    
    define_method "install" do 
      Installer.run(options)
    end
  end
end
