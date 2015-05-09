describe "figaro heroku:set" do
  before do
    create_dir("example")
    cd("example")
    write_file("config/application.yml", "foo: bar")
  end

  it "sends Figaro configuration to Heroku" do
    run_simple("figaro heroku:set")
    expect_ran("heroku", "config:set", "foo=bar")
  end

  it "respects path" do
    write_file("env.yml", "foo: bar")

    run_simple("figaro heroku:set -p env.yml")
    expect_ran("heroku", "config:set", "foo=bar")
  end

  it "respects environment" do
    overwrite_file("config/application.yml", <<-EOF)
foo: bar
test:
  foo: baz
EOF

    run_simple("figaro heroku:set -e test")
    expect_ran("heroku", "config:set", "foo=baz")
  end

  it "targets a specific Heroku app" do
    run_simple("figaro heroku:set -a foo-bar-app")
    expect_ran("heroku", "config:set", "foo=bar", "--app=foo-bar-app")
  end

  it "targets a specific Heroku git remote" do
    run_simple("figaro heroku:set --remote production")
    expect_ran("heroku", "config:set", "foo=bar", "--remote=production")
  end

  it "handles values with special characters" do
    overwrite_file("config/application.yml", "foo: bar baz")

    run_simple("figaro heroku:set")
    expect_ran("heroku", "config:set", "foo=bar baz")
  end
end
