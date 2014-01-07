require "thor"

require "figaro/cli/heroku_set"

module Figaro
  class CLI < Thor
    desc "heroku:set", "Send Figaro configuration to Heroku"

    method_option "app",
      aliases: ["a"],
      desc: "Specify a Heroku app"
    method_option "environment",
      aliases: ["e"],
      default: "development",
      desc: "Specify an application environment"
    method_option "path",
      aliases: ["p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"

    define_method "heroku:set" do
      HerokuSet.run(options)
    end
  end
end
