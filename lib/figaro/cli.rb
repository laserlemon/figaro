require "thor"

module Figaro
  class CLI < Thor
    # figaro install

    desc "install", "Install Figaro"

    method_option "path",
      aliases: ["-p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"

    def install
      require "figaro/cli/install"
      Install.start
    end

    # figaro print <environment>

    desc "print ENVIRONMENT", "Print the specified environment's variables"

    method_option "path",
      aliases: ["-p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"

    define_method "print" do |environment|
      require 'figaro/cli/print'
      Print.run(options.merge(environment: environment))
    end

    # figaro heroku:set

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
    method_option "remote",
      aliases: ["-r"],
      desc: "Specify a Heroku git remote"

    define_method "heroku:set" do
      require "figaro/cli/heroku_set"
      HerokuSet.run(options)
    end
  end
end
