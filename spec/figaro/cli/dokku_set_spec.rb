describe "figaro dokku:set" do
  before do
    create_dir("example")
    cd("example")
    write_file("config/application.yml", "foo: bar")
  end

  it "sends Figaro configuration to dokku" do
    run_simple("figaro dokku:set")

    command = commands.last
    expect(command.name).to eq("dokku")
    expect(command.args).to eq(["config:set", "foo=bar"])
  end

  it "respects path" do
    write_file("env.yml", "foo: bar")

    run_simple("figaro dokku:set -p env.yml")

    command = commands.last
    expect(command.name).to eq("dokku")
    expect(command.args).to eq(["config:set", "foo=bar"])
  end

  it "respects environment" do
    overwrite_file("config/application.yml", <<-EOF)
foo: bar
test:
  foo: baz
    EOF

    run_simple("figaro dokku:set -e test")

    command = commands.last
    expect(command.name).to eq("dokku")
    expect(command.args).to eq(["config:set", "foo=baz"])
  end

  it "handles values with special characters" do
    overwrite_file("config/application.yml", "foo: bar baz")

    run_simple("figaro dokku:set")

    command = commands.last
    expect(command.name).to eq("dokku")
    expect(command.args).to eq(["config:set", "foo=bar baz"])
  end
end
