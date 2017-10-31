require "thor"

require "figaro/cli/command"
require "figaro/cli/error"

module Figaro
  class CLI < ::Thor
    def self.generator_method_options
      method_option :force, type: :boolean, aliases: "-f",
        desc: "Overwrite files that already exist"
      method_option :pretend, type: :boolean, aliases: "-p",
        desc: "Run but do not make any changes"
      method_option :quiet, type: :boolean, aliases: "-q",
        desc: "Suppress status output"
      method_option :skip, type: :boolean, aliases: "-s",
        desc: "Skip files that already exist"
    end

    # figaro exec
    desc "exec COMMAND", "Run a command with Figaro's configuration"
    def exec(*args)
      require "figaro/cli/exec"
      Figaro::CLI::Exec.invoke(args, options)
    end

    # figaro install
    desc "install [name[:type] name[:type]] [options]", "Install Figaro"
    method_option :path,
      default: "env.yml",
      desc: "Specify a path for Figaro's local configuration file"
    generator_method_options
    def install(*variables)
      require "figaro/cli/install"
      invoke Figaro::CLI::Install, variables, options
    end
  end
end
