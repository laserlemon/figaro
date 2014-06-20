require "spec_helper"
require "figaro/cli"

describe "figaro install" do
  before do
    run_simple(<<-CMD)
      rails new example \
        --skip-bundle \
        --skip-keeps \
        --skip-sprockets \
        --skip-javascript \
        --skip-test-unit \
        --no-rc \
        --quiet
      CMD
    cd("example")
  end

  it "inserts application.yml" do
    run_simple("figaro install")
    check_file_presence(["config/application.yml"], true)
  end
  
  it "ignores application.yml" do
    run_simple("figaro install")
    check_file_content(".gitignore", %r(^/config/application\.yml$), true)
  end
  
  it "inserts application.yml into spring config files" do
    run_simple("figaro install --spring")
    check_file_content("config/spring.rb", %r((Spring\.watch).*(\"config\/application\.yml\")), true)
  end
end
