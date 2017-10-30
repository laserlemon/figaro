require "fileutils"

module WorkspaceHelpers
  DIR = File.expand_path("../../workspace", __FILE__)

  def in_workspace(&block)
    create_workspace
    FileUtils.cd(DIR, &block)
    clean_workspace
  end

  def create_workspace
    FileUtils.mkdir_p(DIR)
  end

  def clean_workspace
    FileUtils.rm_rf(DIR)
  end

  def write_envfile(content, path = Figaro::Config::ENVFILE)
    write_file(content, path)
  end

  def write_file(content, path)
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
