require "aruba/api"
require "aruba/cucumber/hooks"

World(Aruba::Api)

Before do
  @aruba_timeout_seconds = 60
end

After "~@no-clobber" do
  FileUtils.rm_rf(current_dir)
end

Before "@heroku_config" do
  @herokuapp = "figaro-test-#{Time.now.to_i}"
end

After "@heroku_config" do
  system("heroku destroy #{@herokuapp} --confirm #{@herokuapp}")
end
