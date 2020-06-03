describe 'figaro print <environment>' do
  before do
    create_dir("example")
    cd("example")
    write_file("config/application.yml", <<-EOF)
foo: bar
production:
  foo: baz
test:
  bar: boink
EOF
  end

  it 'respects path' do
    write_file("env.yml", "different: path")

    cmd = 'figaro print production -p env.yml'
    run_simple cmd
    expect(output_from(cmd)).to eq("different=path\n")
  end

  it 'requires the environment to be specified' do
    cmd = 'figaro print'
    run_simple cmd
    expect(output_from(cmd)).to include('figaro print ENVIRONMENT')
  end

  it 'prints out the production environment' do
    cmd = 'figaro print production'
    run_simple cmd
    expect(output_from(cmd)).to eq("foo=baz\n")
  end

  it 'prints out the test environment' do
    cmd = 'figaro print test'
    run_simple cmd

    expect(output_from(cmd)).to eq("foo=bar\nbar=boink\n")
  end
end
