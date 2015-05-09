describe "figaro eb:set" do
  before do
    create_dir("example")
    cd("example")
    write_file("config/application.yml", "foo: bar")
  end

  it "sends Figaro configuration to Elastic Beanstalk" do
    run_simple("figaro eb:set")
    expect_ran("eb", "setenv", "foo=bar")
  end

  it "respects path" do
    write_file("env.yml", "foo: bar")

    run_simple("figaro eb:set -p env.yml")
    expect_ran("eb", "setenv", "foo=bar")
  end

  it "respects environment" do
    overwrite_file("config/application.yml", <<-EOF)
foo: bar
test:
  foo: baz
EOF

    run_simple("figaro eb:set -e test")
    expect_ran("eb", "setenv", "foo=baz")
  end

  it "handles values with special characters" do
    overwrite_file("config/application.yml", "foo: bar baz")

    run_simple("figaro eb:set")
    expect_ran("eb", "setenv", "foo=bar baz")
  end

  it "targets a Elastic Beanstalk environment" do
    run_simple("figaro eb:set --eb-env=beanstalk-env")
    expect_ran("eb", "setenv", "foo=bar", "--environment=beanstalk-env")
  end

  it "targets a specific region" do
    run_simple("figaro eb:set --region=us-east-1")
    expect_ran("eb", "setenv", "foo=bar", "--region=us-east-1")

    run_simple("figaro eb:set -r us-east-1")
    expect_ran("eb", "setenv", "foo=bar", "--region=us-east-1")
  end

  it "targets a specific profile" do
    run_simple("figaro eb:set --profile=awesomecreds")
    expect_ran("eb", "setenv", "foo=bar", "--profile=awesomecreds")
  end

  it "respects a given timeout" do
    run_simple("figaro eb:set --timeout=1")
    expect_ran("eb", "setenv", "foo=bar", "--timeout=1")
  end

  it "respects a no-verify-ssl" do
    run_simple("figaro eb:set --no-verify-ssl")
    expect_ran("eb", "setenv", "foo=bar", "--no-verify-ssl")
  end
end
