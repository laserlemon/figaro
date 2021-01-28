describe 'figaro rhc:set' do
  before do
    create_dir('example')
    cd('example')
    write_file('config/application.yml', 'foo: bar')
  end

  it 'sends Figaro configuration to OpenShift' do
    run_simple('figaro rhc:set')

    command = commands.last
    expect(command.name).to eq('rhc')
    expect(command.args).to eq(['env-set', 'foo=bar'])
  end

  it 'respects path' do
    write_file('env.yml', 'foo: bar')

    run_simple('figaro rhc:set -p env.yml')

    command = commands.last
    expect(command.name).to eq('rhc')
    expect(command.args).to eq(['env-set', 'foo=bar'])
  end

  it 'respects environment' do
    overwrite_file('config/application.yml', <<-EOF)
foo: bar
test:
  foo: baz
EOF

    run_simple('figaro rhc:set -e test')

    command = commands.last
    expect(command.name).to eq('rhc')
    expect(command.args).to eq(['env-set', 'foo=baz'])
  end

  it 'targets a specific OpenShift app' do
    run_simple('figaro rhc:set -a foo-bar-app')

    command = commands.last
    expect(command.name).to eq('rhc')
    expect(command.args.shift).to eq('env-set')
    expect(command.args).to match_array(['foo=bar', '--app', 'foo-bar-app'])
  end

  it 'targets a specific OpenShift namespace' do
    run_simple('figaro rhc:set -a fooapp -n teambar')

    command = commands.last
    expect(command.name).to eq('rhc')
    expect(command.args.shift).to eq('env-set')
    expect(command.args).to match_array(['foo=bar', '--app',
                                         'fooapp', '--namespace', 'teambar'])
  end

  it 'handles values with special characters' do
    overwrite_file('config/application.yml', 'foo: bar baz')

    run_simple('figaro rhc:set')

    command = commands.last
    expect(command.name).to eq('rhc')
    expect(command.args).to eq(['env-set', 'foo=bar baz'])
  end
end
