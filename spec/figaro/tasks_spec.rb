require "spec_helper"

describe "Figaro Rake tasks", :rake => true do
  describe "figaro:heroku" do
    before do
      @original_rails_env = ENV["RAILS_ENV"]
      ENV["RAILS_ENV"] = "development"
    end

    after do
      ENV["RAILS_ENV"] = @original_rails_env
      Rails.send(:remove_instance_variable, :@_env)
    end

    it "configures Heroku" do
      Figaro.stub(:env => {"HELLO" => "world", "FOO" => "bar"})
      Kernel.stub(:system).with("heroku config:get RAILS_ENV").and_return("development")
      Kernel.should_receive(:system).once.with("heroku config:add FOO=bar HELLO=world")
      task.invoke
    end

    it "configures a specific Heroku app" do
      Figaro.stub(:env => {"HELLO" => "world", "FOO" => "bar"})
      Kernel.stub(:system).with("heroku config:get RAILS_ENV --app my-app").and_return("development")
      Kernel.should_receive(:system).once.with("heroku config:add FOO=bar HELLO=world --app my-app")
      task.invoke("my-app")
    end

    it "respects the Heroku's remote Rails environment" do
      Figaro.stub(:raw => {"development" => {"HELLO" => "developers"}, "production" => {"HELLO" => "world"}})
      Kernel.stub(:system).with("heroku config:get RAILS_ENV").and_return("production")
      Kernel.should_receive(:system).once.with("heroku config:add HELLO=world")
      task.invoke
    end

    it "defaults to the local Rails environment if not set remotely" do
      Figaro.stub(:raw => {"development" => {"HELLO" => "developers"}, "production" => {"HELLO" => "world"}})
      Kernel.stub(:system).with("heroku config:get RAILS_ENV").and_return("\n")
      Kernel.should_receive(:system).once.with("heroku config:add HELLO=developers")
      task.invoke
    end
  end
end
