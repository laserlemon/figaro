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

    # figaro eb:set

    desc "eb:set", "Send Figaro configuration to Elastic Beanstalk"

    method_option "eb-env",
      desc: "Specify the Elastic Beanstalk environment to target"
    method_option "environment",
      aliases: ["-e"],
      desc: "Specify an application environment"
    method_option "path",
      aliases: ["-p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"
    method_option "profile",
      desc: "Use a specific profile from your credential file"
    method_option "verify-ssl",
      type: :boolean,
      desc: "Whether to verify AWS SSL certificates",
      default: true

    method_option "region",
      aliases: ["-r"],
      desc: "Use a specific region"
    method_option "timeout",
      desc: "The number of minutes before the command times out"

    define_method "eb:set" do
      require "figaro/cli/eb_set"
      EBSet.run(options)
    end
  end
end
