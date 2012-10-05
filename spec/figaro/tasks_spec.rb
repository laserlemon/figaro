require "spec_helper"

describe "Figaro Rake tasks", :rake => true do
  describe "figaro:heroku" do
    it "configures Heroku" do
      Figaro.stub(:env => {"HELLO" => "world", "FOO" => "bar"})
      Kernel.should_receive(:system).once.with("heroku config:add FOO=bar HELLO=world")
      task.invoke
    end

    it "configures a specific Heroku app" do
      Figaro.stub(:env => {"HELLO" => "world", "FOO" => "bar"})
      Kernel.should_receive(:system).once.with("heroku config:add FOO=bar HELLO=world --app my-app")
      task.invoke("my-app")
    end
  end

  describe "figaro:cloudbees" do
    it "configures Cloudbees" do
      Figaro.stub(:env => {"HELLO" => "world", "FOO" => "bar"})
      Kernel.should_receive(:system).once.with("bees config:set FOO=bar HELLO=world")
      task.invoke
    end

    it "configures a specific Cloudbees app" do
      Figaro.stub(:env => {"HELLO" => "world", "FOO" => "bar"})
      Kernel.should_receive(:system).once.with("bees config:set FOO=bar HELLO=world -a my-app")
      task.invoke("my-app")
    end
  end
end
