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

    # figaro dokku:set

    desc "dokku:set", "Send Figaro configuration to a Dokku app."
    long_desc <<-LONGDESC
      Sends the Figaro configuration to a Dokku APP on the Dokku SERVER.

      Since Dokku does not provide a client, this command requires that:\n\n
      1. Add git remote dokku repository\n\n
      2. Do following command `gem install dokku-cli`
      \n\n
    LONGDESC

    method_option "environment",
      aliases: ["-e"],
      desc: "Specify an application environment"
    method_option "path",
      aliases: ["-p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"
 
    define_method "dokku:set" do
      require "figaro/cli/dokku_set"
      DokkuSet.run(options)
    end

  end
end
