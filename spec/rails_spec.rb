require "spec_helper"

describe Figaro::Rails do
  before do
    run_simple(<<-CMD)
      rails new example \
        --skip-gemfile \
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

  describe "initialization" do
    before do
      write_file("config/application.yml", "foo: bar")
    end

    it "loads application.yml" do
      run_simple("rails runner 'puts Figaro.env.foo'")

      assert_partial_output("bar", all_stdout)
    end

    it "happens before database initialization" do
      write_file("config/database.yml", <<-EOF)
development:
  adapter: sqlite3
  database: db/<%= ENV["foo"] %>.sqlite3
EOF

      run_simple("rake db:migrate")

      check_file_presence(["db/bar.sqlite3"], true)
    end

    it "happens before application configuration" do
      insert_into_file_after("config/application.rb", /< Rails::Application$/, <<-EOL)
    config.foo = ENV["foo"]
EOL

      run_simple("rails runner 'puts Rails.application.config.foo'")

      assert_partial_output("bar", all_stdout)
    end
  end

  describe "rails generate figaro:install" do
    it "generates application.yml" do
      run_simple("rails generate figaro:install")

      check_file_presence(["config/application.yml"], true)
    end

    it "ignores application.yml" do
      run_simple("rails generate figaro:install")

      check_file_content(".gitignore", %r(^/config/application\.yml$), true)
    end
    
    it "inserts application.yml into spring config files" do
      run_simple("rails generate figaro:install")
      check_file_content("config/spring.rb", %r((Spring\.watch).*(\"config\/application\.yml\")), true)
    end
    
  end
end
