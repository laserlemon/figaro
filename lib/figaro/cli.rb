require "thor"

module Figaro
  class CLI < Thor
    def self.generator_method_options
      method_option :force,
        aliases: "-f",
        desc: "Overwrite files that already exist",
        type: :boolean
      method_option :pretend,
        aliases: "-p",
        desc: "Run but do not make any changes",
        type: :boolean
      method_option :quiet,
        aliases: "-q",
        desc: "Suppress status output",
        type: :boolean
      method_option :skip,
        aliases: "-s",
        desc: "Skip files that already exist",
        type: :boolean
    end

    # figaro install
    desc "install [name[:type] name[:type]] [options]", "Install Figaro"
    method_option :path,
      default: "env.yml",
      desc: "Specify a path for Figaro's local configuration file"
    generator_method_options
    def install(*variables)
      require "figaro/cli/install"
      invoke Install, variables, options
    end
  end
end
