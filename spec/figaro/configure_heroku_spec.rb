require "spec_helper"

describe Figaro::ConfigureHeroku do

  describe "execute" do

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
      subject.should_receive(:`).with("heroku config:get RAILS_ENV").and_return("development")
      subject.should_receive(:`).with("heroku config:add FOO=bar HELLO=world")
      subject.execute
    end

    it "configures a specific Heroku app" do
      Figaro.stub(:env => {"HELLO" => "world", "FOO" => "bar"})
      subject.should_receive(:`).with("heroku config:get RAILS_ENV --app my-app").and_return("development")
      subject.should_receive(:`).with("heroku config:add FOO=bar HELLO=world --app my-app")
      subject.execute(app: "my-app")
    end

    it "respects the Heroku's remote Rails environment" do
      Figaro.stub(:raw => {"development" => {"HELLO" => "developers"}, "production" => {"HELLO" => "world"}})
      subject.should_receive(:`).with("heroku config:get RAILS_ENV").and_return("production")
      subject.should_receive(:`).with("heroku config:add HELLO=world")
      subject.execute
    end

    it "defaults to the local Rails environment if not set remotely" do
      Figaro.stub(:raw => {"development" => {"HELLO" => "developers"}, "production" => {"HELLO" => "world"}})
      subject.should_receive(:`).with("heroku config:get RAILS_ENV").and_return("\n")
      subject.should_receive(:`).with("heroku config:add HELLO=developers")
      subject.execute
    end
  end
end