require "thor"

require "figaro/cli/heroku_set"
require "figaro/cli/travis_encrypt"

module Figaro
  class CLI < Thor
    stop_on_unknown_option! :'travis:encrypt'
    check_unknown_options! except: :'travis:encrypt'

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

    define_method "travis:encrypt" do |*args|
      TravisEncrypt.run(options.merge(extra_args: args))
    end

    def self.exit_on_failure?
      true
    end
  end
end
