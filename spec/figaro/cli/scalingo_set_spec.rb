describe "figaro scalingo:set" do
  before do
    create_dir("example")
    cd("example")
    write_file("config/application.yml", "foo: bar")
  end

  it "sends Figaro configuration to Scalingo" do
    run_simple("figaro scalingo:set")

    command = commands.last
    expect(command.name).to eq("scalingo")
    expect(command.args).to eq(["env-set", "foo=bar"])
  end

  it "respects path" do
    write_file("env.yml", "foo: bar")

    run_simple("figaro scalingo:set -p env.yml")

    command = commands.last
    expect(command.name).to eq("scalingo")
    expect(command.args).to eq(["env-set", "foo=bar"])
  end

  it "respects environment" do
    overwrite_file("config/application.yml", <<-EOF)
foo: bar
test:
  foo: baz
EOF

    run_simple("figaro scalingo:set -e test")

    command = commands.last
    expect(command.name).to eq("scalingo")
    expect(command.args).to eq(["env-set", "foo=baz"])
  end

  it "targets a specific Scalingo app" do
    run_simple("figaro scalingo:set -a foo-bar-app")

    command = commands.last
    expect(command.name).to eq("scalingo")
    expect(command.args).to match_array(["--app", "foo-bar-app", "env-set", "foo=bar"])
  end

  it "targets a specific Scalingo git remote" do
    run_simple("figaro scalingo:set -r production")

    command = commands.last
    expect(command.name).to eq("scalingo")
    expect(command.args).to match_array(["--remote", "production", "env-set", "foo=bar"])
  end

  it "handles values with special characters" do
    overwrite_file("config/application.yml", "foo: bar baz")

    run_simple("figaro scalingo:set")

    command = commands.last
    expect(command.name).to eq("scalingo")
    expect(command.args).to eq(["env-set", "foo=bar baz"])
  end
end
