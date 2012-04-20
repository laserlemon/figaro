require "aruba/api"
require "aruba/cucumber/hooks"

World(Aruba::Api)

Before do
  @aruba_timeout_seconds = 60
end

After do
  FileUtils.rm_rf(current_dir)
end
