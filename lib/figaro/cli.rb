require "thor"

require "figaro/cli/heroku_set"

module Figaro
  class CLI < Thor
    desc "heroku:set", "Send Figaro configuration to Heroku"

    option "app",
      aliases: ["a"],
      desc: "Specify a Heroku app"
    option "environment",
      aliases: ["e"],
      default: "development",
      desc: "Specify an application environment"
    option "path",
      aliases: ["p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"

    define_method "heroku:set" do
      HerokuSet.run(options)
    end
  end
end
