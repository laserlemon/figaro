# frozen_string_literal: true

require "fileutils"

module WorkspaceHelpers
  DIR = File.expand_path("../workspace", __dir__)

  def in_workspace
    create_workspace
    original_directory = get_directory
    change_directory(DIR)
    yield
  ensure
    change_directory(original_directory)
    clean_workspace
  end

  def create_workspace
    create_directory(DIR)
  end

  def clean_workspace
    FileUtils.rm_rf(DIR)
  end

  def write_envfile(content, path = Figaro::Config.default_envfile_path)
    write_file(content, path)
  end

  def write_file(content, path)
    File.open(path, "w") { |file| file << content }
  end

  def create_directory(path)
    FileUtils.mkdir_p(path)
  end

  def change_directory(path)
    FileUtils.cd(path)
  end

  def get_directory
    FileUtils.pwd
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
