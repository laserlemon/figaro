require "spec_helper"

describe "Figaro Rake tasks", :rake => true do
  def common_test(expect_cmd, app=nil)
    Figaro.stub(:env => {"HELLO" => "world", "FOO" => "bar"})
    Kernel.should_receive(:system).once.with(expect_cmd)
    task.invoke(app)
  end

  describe "figaro:heroku" do
    it "configures Heroku" do
      common_test "heroku config:add FOO=bar HELLO=world"
    end

    it "configures a specific Heroku app" do
      common_test "heroku config:add FOO=bar HELLO=world --app my-app", "my-app"
    end
  end

  describe "figaro:cloudbees" do
    it "configures Cloudbees" do
      common_test "bees config:set FOO=bar HELLO=world"
    end

    it "configures a specific Cloudbees app" do
      common_test "bees config:set FOO=bar HELLO=world -a my-app", "my-app"
    end
  end
  
  describe "figaro:heroku_test" do
    it "echoes commands to configure Heroku" do
      common_test "echo heroku config:add FOO=bar HELLO=world"
    end

    it "echoes commands to configure a specific Heroku app" do
      common_test "echo heroku config:add FOO=bar HELLO=world --app my-app", "my-app"
    end
  end


  describe "figaro:cloudbees_test" do
    it "echoes commands to configure Cloudbees" do
      common_test "echo bees config:set FOO=bar HELLO=world"
    end
  
    it "echoes commands to configure Cloudbees app" do
      common_test "echo bees config:set FOO=bar HELLO=world -a my-app", "my-app"
    end
  end

end
