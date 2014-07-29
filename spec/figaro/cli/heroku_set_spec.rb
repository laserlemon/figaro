require "spec_helper"

describe "figaro heroku:set" do
  before do
    create_dir("example")
    cd("example")
    write_file("config/application.yml", "foo: bar")
  end

  it "sends Figaro configuration to Heroku" do
    run_simple("figaro heroku:set")

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args).to eq(["config:set", "foo=bar"])
  end

  it "respects path" do
    write_file("env.yml", "foo: bar")

    run_simple("figaro heroku:set -p env.yml")

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args).to eq(["config:set", "foo=bar"])
  end

  it "respects environment" do
    overwrite_file("config/application.yml", <<-EOF)
foo: bar
test:
  foo: baz
EOF

    run_simple("figaro heroku:set -e test")

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args).to eq(["config:set", "foo=baz"])
  end

  it "targets a specific Heroku app" do
    run_simple("figaro heroku:set -a foo-bar-app")

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args.shift).to eq("config:set")
    expect(command.args).to match_array(["foo=bar", "--app=foo-bar-app"])
  end

  it "handles values with special characters" do
    overwrite_file("config/application.yml", "foo: bar baz")

    run_simple("figaro heroku:set")

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args).to eq(["config:set", "foo=bar baz"])
  end

  it "handles values that are of Fixnum class" do
    overwrite_file("config/application.yml", <<-EOF)
foo: 4815162342
test:
  foo: 4815162342
EOF

    run_simple("figaro heroku:set -e test")

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args).to eq(["config:set", "foo=4815162342"])
  end

  it "handles values of many special characters" do
    overwrite_file("config/application.yml", <<-EOF)
test_config_value: 1!2@3#4\\$5%6^7&8*9(0)1-2_3=4+5'6'7'8\\"9\\"0\\"1.2,3<4>5:6;7\\`8~9[0]1{2}
test:
  test_config_value: 1!2@3#4\\$5%6^7&8*9(0)1-2_3=4+5'6'7'8\\"9\\"0\\"1.2,3<4>5:6;7\\`8~9[0]1{2}
EOF

    run_simple("figaro heroku:set -e test")

    command = commands.last
    expect(command.name).to eq("heroku")
    expect(command.args).to eq(["config:set", "test_config_value=1!2@3#4$5%6^7&8*9(0)1-2_3=4+5'6'7'8\"9\"0\"1.2,3<4>5:6;7\`8~9[0]1{2}"])
  end
end
