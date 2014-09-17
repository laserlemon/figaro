describe "figaro install" do
  before do
    create_dir("example")
    cd("example")
  end

  it "creates a configuration file" do
    run_simple("figaro install")

    check_file_presence(["config/application.yml"], true)
  end

  it "respects path" do
    run_simple("figaro install -p env.yml")

    check_file_presence(["env.yml"], true)
  end

  context "with a .gitignore file" do
    before do
      write_file(".gitignore", <<-EOF)
/foo
/bar
EOF
    end

    it "Git-ignores the configuration file if applicable" do
      run_simple("figaro install")

      check_file_content(".gitignore", %r(^/foo$), true)
      check_file_content(".gitignore", %r(^/bar$), true)
      check_file_content(".gitignore", %r(^/config/application\.yml$), true)
    end

    it "respects path" do
      run_simple("figaro install -p env.yml")

      check_file_content(".gitignore", %r(^/env\.yml$), true)
    end
  end

  context "without a .gitignore file" do
    it "doesn't generate a new .gitignore file" do
      run_simple("figaro install")

      check_file_presence([".gitignore"], false)
    end
  end
end
