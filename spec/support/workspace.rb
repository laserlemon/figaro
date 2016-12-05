require "fileutils"

module WorkspaceHelpers
  DIR = File.join("spec", "workspace")

  def in_workspace
    FileUtils.mkdir_p(DIR)

    FileUtils.cd(DIR) do
      clean_workspace

      begin
        yield
      ensure
        clean_workspace
      end
    end
  end

  def clean_workspace
    FileUtils.rm(Dir["*"])
  end

  def write_envfile(content, path: "Envfile")
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
end
