require "aruba/api"

module ArubaHelpers
  def insert_into_file_after(file, pattern, addition)
    content = cd(".") { IO.read(file) }
    content.sub!(pattern, "\\0\n#{addition}")
    overwrite_file(file, content)
  end
end

RSpec.configure do |config|
  config.include(Aruba::Api)
  config.include(ArubaHelpers)

  config.before do
    setup_aruba
  end
end
