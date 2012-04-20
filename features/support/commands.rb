module CommandHelpers
  PATH = ROOT.join("tmp/commands")

  def write_command(command, content)
    path = PATH.join(command)
    File.open(path, "w"){|f| f << content }
    FileUtils.chmod(0755, path)
  end

  def patch_path
    FileUtils.mkdir_p(PATH)
    @original_paths = ENV["PATH"] ? ENV["PATH"].split(File::PATH_SEPARATOR) : []
    ENV["PATH"] = ([PATH] + @original_paths).join(File::PATH_SEPARATOR)
  end

  def restore_path
    ENV["PATH"] = @original_paths.join(File::PATH_SEPARATOR)
    FileUtils.rm_r(PATH)
  end
end

World(CommandHelpers)

Before do
  patch_path
end

After do
  restore_path
end
