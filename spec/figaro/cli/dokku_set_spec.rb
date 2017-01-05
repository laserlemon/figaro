describe "figaro dokku:set" do
  before do
    create_dir("example")
    cd("example")
    write_file("config/application.yml", "foo: bar")

    # setup cmd-line base
    @cli_input_base = "figaro dokku:set --app=foo-bar-app --server=dokku-server"
    # setup common expected values
    @cmd = "ssh"
    @args_base = ["dokku@dokku-server", "config:set", "foo-bar-app"]
  end

  it "sends Figaro configuration to a Dokku app" do
    run_simple(@cli_input_base)

    command = commands.last
    expect(command.name).to eq(@cmd)
    expect(command.args).to eq(@args_base << "foo=bar")
  end

  it "fails if a Dokku app is not specified" do
    run_simple("figaro dokku:set --server=dokku-server")

    command = commands.last
    expect(command).to be_nil
  end

  it "fails if a Dokku server is not specified" do
    run_simple("figaro dokku:set --app=foo-bar-app")

    command = commands.last
    expect(command).to be_nil
  end

  it "respects path" do
    write_file("env.yml", "foo: bar")

    run_simple(@cli_input_base + " -p env.yml")

    command = commands.last
    expect(command.name).to eq(@cmd)
    expect(command.args).to eq(@args_base << "foo=bar")
  end

  it "respects environment" do
    overwrite_file("config/application.yml", <<-EOF)
foo: bar
test:
  foo: baz
EOF

    run_simple(@cli_input_base + " -e test")

    command = commands.last
    expect(command.name).to eq(@cmd)
    expect(command.args).to eq(@args_base << "foo=baz")
  end

  it "handles values with special characters" do
    overwrite_file("config/application.yml", "foo: bar baz")

    run_simple(@cli_input_base)

    command = commands.last
    expect(command.name).to eq(@cmd)
    expect(command.args).to eq(@args_base << "foo=bar baz")
  end
end
