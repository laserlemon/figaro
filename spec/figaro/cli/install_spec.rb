describe "figaro install" do
  before do
    create_directory("example")
    cd("example")
  end

  it "creates a configuration file" do
    run_command_and_stop("figaro install")

    expect("config/application.yml").to be_an_existing_file
  end

  it "respects path" do
    run_command_and_stop("figaro install -p env.yml")

    expect("env.yml").to be_an_existing_file
  end

  context "with a .gitignore file" do
    before do
      write_file(".gitignore", <<-EOF)
/foo
/bar
EOF
    end

    it "Git-ignores the configuration file if applicable" do
      run_command_and_stop("figaro install")

      expect(".gitignore").to have_file_content(%r(^/foo$))
      expect(".gitignore").to have_file_content(%r(^/bar$))
      expect(".gitignore").to have_file_content(%r(^/config/application\.yml$))
    end

    it "respects path" do
      run_command_and_stop("figaro install -p env.yml")

      expect(".gitignore").to have_file_content(%r(^/env\.yml$))
    end
  end

  context "without a .gitignore file" do
    it "doesn't generate a new .gitignore file" do
      run_command_and_stop("figaro install")

      expect(".gitignore").not_to be_an_existing_file
    end
  end
end
