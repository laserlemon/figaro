require "aruba/api"

module ArubaHelpers
  def insert_into_file_after(file, pattern, addition)
    content = prep_for_fs_check { IO.read(file) }
    content.sub!(pattern, "\\0\n#{addition}")
    overwrite_file(file, content)
  end
end

RSpec.configure do |config|
  config.include(Aruba::Api)
  config.include(ArubaHelpers)

  config.before do
    @aruba_timeout_seconds = 60
    FileUtils.rm_rf(current_dir)
  end
end
