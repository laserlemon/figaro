describe 'figaro eb:set' do
  before do
    create_dir('example')
    cd('example')
    write_file('config/application.yml', 'foo: bar')
  end

  it 'sends Figaro configuration to Elasticbeanstalk' do
    run_simple('figaro eb:set')

    command = commands.last
    expect(command.name).to eq('eb')
    expect(command.args).to eq(['setenv', 'foo=bar'])
  end

  it 'respects path' do
    write_file('env.yml', 'foo: bar')

    run_simple('figaro eb:set -p env.yml')

    command = commands.last
    expect(command.name).to eq('eb')
    expect(command.args).to eq(['setenv', 'foo=bar'])
  end

  it 'respects environment' do
    overwrite_file('config/application.yml', <<-EOF)
foo: bar
test:
  foo: baz
EOF

    run_simple('figaro eb:set -e test')

    command = commands.last
    expect(command.name).to eq('eb')
    expect(command.args).to eq(['setenv', 'foo=baz'])
  end

  it 'targets a specific AWS profile' do
    run_simple('figaro eb:set --profile foo-bar-app')

    command = commands.last
    expect(command.name).to eq('eb')
    expect(command.args.shift).to eq('setenv')
    expect(command.args).to match_array(['foo=bar', '--profile foo-bar-app'])
  end

  it 'targets a specific Elasticbeanstalk environment' do
    run_simple('figaro eb:set --env production')

    command = commands.last
    expect(command.name).to eq('eb')
    expect(command.args.shift).to eq('setenv')
    expect(command.args).to match_array(['foo=bar', '-e production'])
  end

  it 'targets a verbose output' do
    run_simple('figaro eb:set --verbose')

    command = commands.last
    expect(command.name).to eq('eb')
    expect(command.args.shift).to eq('setenv')
    expect(command.args).to match_array(['foo=bar', '--verbose'])
  end

  it 'handles values with special characters' do
    overwrite_file('config/application.yml', 'foo: bar baz')

    run_simple('figaro eb:set')

    command = commands.last
    expect(command.name).to eq('eb')
    expect(command.args).to eq(['setenv', 'foo=bar baz'])
  end
end
