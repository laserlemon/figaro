require "spec_helper"

require "figaro/cli"

describe "figaro travis:encrypt" do
  before do
    create_dir("example")
    cd("example")
    write_file("config/application.yml", "foo: bar")
  end

  it "sends Figaro configuration to travis encrypt" do
    run_simple("figaro travis:encrypt")

    command = commands.last
    expect(command.name).to eq("travis")
    expect(command.args).to eq(["encrypt", "--split", "foo=bar"])
  end

  it "respects path" do
    write_file("env.yml", "foo: bar")

    run_simple("figaro travis:encrypt -p env.yml")

    command = commands.last
    expect(command.name).to eq("travis")
    expect(command.args).to eq(["encrypt", "--split", "foo=bar"])
  end

  it "respects environment" do
    overwrite_file("config/application.yml", <<-EOF)
foo: bar
test:
  foo: baz
EOF

    run_simple("figaro travis:encrypt -e test")

    command = commands.last
    expect(command.name).to eq("travis")
    expect(command.args).to eq(["encrypt", "--split", "foo=baz"])
  end

  it "handles values with special characters" do
    overwrite_file("config/application.yml", "foo: bar baz")

    run_simple("figaro travis:encrypt")

    command = commands.last
    expect(command.name).to eq("travis")
    expect(command.args).to eq(["encrypt", "--split", "foo=bar baz"])
  end

  it "handles multiple values" do
    append_to_file('config/application.yml', "\ndead: beef")

    run_simple("figaro travis:encrypt")

    command = commands.last
    expect(command.name).to eq("travis")
    expect(command.args).to eq(["encrypt", "--split", "foo=bar\ndead=beef"])
  end

  it 'passes unknown options to travis' do
    run_simple("figaro travis:encrypt --awesome")

    command = commands.last
    expect(command.name).to eq("travis")
    expect(command.args).to eq(["encrypt", "--awesome", "--split", "foo=bar"])
  end

  it 'allows the user to override the split option' do
    run_simple("figaro travis:encrypt --no-split")

    command = commands.last
    expect(command.name).to eq("travis")
    expect(command.args).to eq(["encrypt", "--no-split", "foo=bar"])
  end
end
