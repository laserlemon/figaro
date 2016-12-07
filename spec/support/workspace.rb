require "fileutils"

module WorkspaceHelpers
  DIR = File.join("spec", "workspace")

  def in_workspace
    FileUtils.mkdir_p(DIR)
    clean_workspace
    FileUtils.cd(DIR) { yield }
  end

  def clean_workspace
    FileUtils.rm(Dir[File.join(DIR, "*")])
  end

  module_function :clean_workspace

  def write_envfile(content, path: "Envfile")
    write_file(content, path: path)
  end

  def write_file(content, path:)
    File.open(path, "w") { |file| file << content }
  end
end

RSpec.configure do |config|
  config.include(WorkspaceHelpers)

  config.around do |example|
    in_workspace do
      example.run
    end
  end

  config.after(:suite) do
    WorkspaceHelpers.clean_workspace
  end
end
