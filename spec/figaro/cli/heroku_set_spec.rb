require "spec_helper"

require "figaro/cli"

describe "figaro heroku:set" do
  before do
    create_dir("example")
    cd("example")
    write_file("config/application.yml", "foo: bar")
  end

  it "sends Figaro configuration to Heroku" do
    expect {
      run_simple("figaro heroku:set -e development")
    }.to change {
      commands.count
    }.from(0).to(1)

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args).to eq(["config:set", "foo=bar"])
  end

  it "requires environment" do
    expect {
      run_simple("figaro heroku:set")
    }.not_to change {
      commands.count
    }
  end

  it "respects environment" do
    overwrite_file("config/application.yml", <<-EOF)
foo: bar
test:
  foo: baz
EOF

    expect {
      run_simple("figaro heroku:set -e test")
    }.to change {
      commands.count
    }.from(0).to(1)

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args).to eq(["config:set", "foo=baz"])
  end

  it "respects path" do
    write_file("env.yml", "foo: bar")

    expect {
      run_simple("figaro heroku:set -e development -p env.yml")
    }.to change {
      commands.count
    }.from(0).to(1)

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args).to eq(["config:set", "foo=bar"])
  end

  it "targets a specific Heroku app" do
    expect {
      run_simple("figaro heroku:set -e development -a foo-bar-app")
    }.to change {
      commands.count
    }.from(0).to(1)

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args.shift).to eq("config:set")
    expect(command.args).to match_array(["foo=bar", "--app=foo-bar-app"])
  end
end
