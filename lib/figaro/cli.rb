# frozen_string_literal: true

require "thor"

require_relative "cli/error"

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
    def exec(command, *args)
      require_relative "cli/exec"
      Figaro::CLI::Exec.invoke(command, args, options)
    end

    # figaro install
    desc "install [name[:type] name[:type]] [options]", "Install Figaro"
    method_option :path,
      default: "env.yml",
      desc: "Specify a path for Figaro's local configuration file"
    generator_method_options
    def install(*args)
      require_relative "cli/install"
      invoke Figaro::CLI::Install, args, options
    end
  end
end
