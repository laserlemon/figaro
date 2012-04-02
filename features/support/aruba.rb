require "aruba/api"
require "aruba/cucumber/hooks"

World(Aruba::Api)

Before do
  @aruba_timeout_seconds = 10
end
