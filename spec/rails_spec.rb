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
    it "loads application.yml" do
      write_file("config/application.yml", "HELLO: world")
      run_simple("rails runner 'puts Figaro.env.hello'")

      assert_partial_output("world", all_stdout)
    end

    it "happens before database initialization" do
      write_file("config/database.yml", <<-EOF)
development:
  adapter: sqlite3
  database: db/<%= ENV["FOO"] %>.sqlite3
EOF
      write_file("config/application.yml", "FOO: bar")
      run_simple("rake db:migrate")

      check_file_presence(["db/bar.sqlite3"], true)
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
  end

  describe "rake figaro:heroku" do
    it "is included" do
      run_simple("rake --tasks figaro:heroku")

      assert_partial_output("rake figaro:heroku[app]  # Configure Heroku according to application.yml", all_stdout)
    end
  end
end
