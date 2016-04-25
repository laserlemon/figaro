require "thor"

module Figaro
  class CLI < Thor

    class_option "path", aliases: ["-p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"

    class_option "environment", aliases: ["-e"],
      desc: "Specify an application environment"
    #
    # figaro install
    #
    desc "install", "Install Figaro"

    def install
      require "figaro/cli/install"
      Install.start
    end

    #
    # figaro show
    #
    desc "show", "Show the parsed config"
    def show
      require "figaro/cli/show"
      Show.run(options)
    end

    #
    # figaro heroku:set
    #
    desc "heroku:set", "Send Figaro configuration to Heroku"

    method_option "app", aliases: ["-a"],
      desc: "Specify a Heroku app"

    method_option "remote", aliases: ["-r"],
      desc: "Specify a Heroku git remote"        

    define_method "heroku:set" do
      require "figaro/cli/heroku_set"
      HerokuSet.run(options)
    end

  end
end
