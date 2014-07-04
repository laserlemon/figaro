require "thor"

require "figaro/cli/heroku_set"
require "figaro/cli/travis_encrypt"

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

    desc "travis:encrypt", "Encrypt Figaro configuration for .travis.yml"

    method_option "environment",
      aliases: ["-e"],
      desc: "Specify an application environment"
    method_option "path",
      aliases: ["-p"],
      default: "config/application.yml",
      desc: "Specify a configuration file path"
    method_option "add",
      type: :boolean,
      desc: "Add to .travis.yml"
    method_option "override",
      type: :boolean,
      desc: "Override existing env vars in .travis.yml"

    define_method "travis:encrypt" do
      TravisEncrypt.run(options)
    end
  end
end
