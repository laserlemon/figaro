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
      desc: "Specify a Heroku git remote"

    define_method "heroku:set" do
      require "figaro/cli/heroku_set"
      HerokuSet.run(options)
    end

    # figaro dokku:set

    desc "dokku:set --app=<app> --server=<server>", "Send Figaro configuration to a Dokku app."
    long_desc <<-LONGDESC
      Sends the Figaro configuration to a Dokku app named <app> on Dokku server <server>.

      Since Dokku does not provide a client, this command requires that:
      1. the local machine has ssh access to the Dokku server for the 'dokku' user
      2. the Dokku server  (e.g. dokku-example.com)
      3. the app name
    LONGDESC

    method_option "app",
      required: true, 
      aliases: ["-a"],
      desc: "Specify a Dokku app"
    method_option "environment",
      aliases: ["-e"],
      desc: "Specify an application environment"
    method_option "path",
      aliases: ["-p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"
    method_option "server",
      required: true,
      aliases: ["-s"],
      desc: "Specify a Dokku server (dokku-example.com)"
 
    define_method "dokku:set" do
      require "figaro/cli/dokku_set"
      DokkuSet.run(options)
    end

  end
end
