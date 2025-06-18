describe Figaro::Rails do
  before do
    run_command_and_stop(<<-CMD)
      rails new example \
        --api \
        --minimal \
        --no-rc \
        --skip-asset-pipeline \
        --skip-bootsnap \
        --skip-bundle \
        --skip-gemfile \
        --skip-git \
        --skip-javascript \
        --skip-keeps \
        --skip-listen \
        --skip-spring \
        --skip-sprockets \
        --skip-test \
        --skip-turbolinks \
        --skip-webpack-install \
        --skip-yarn
      CMD
    cd("example")
  end

  describe "initialization" do
    before do
      write_file("config/application.yml", "foo: bar")
    end

    it "loads application.yml" do
      run_command_and_stop("rails runner 'puts Figaro.env.foo'")

      expect(all_stdout).to include("bar")
    end

    it "happens before database initialization" do
      write_file("config/database.yml", <<-EOF)
development:
  adapter: sqlite3
  database: db/<%= ENV["foo"] %>.sqlite3
EOF

      run_command_and_stop("rake db:migrate")

      expect("db/bar.sqlite3").to be_an_existing_file
    end

    it "happens before application configuration" do
      insert_into_file_after("config/application.rb", /< Rails::Application$/, <<-EOL)
    config.foo = ENV["foo"]
EOL

      run_command_and_stop("rails runner 'puts Rails.application.config.foo'")

      expect(all_stdout).to include("bar")
    end
  end
end
