require "spec_helper"

module Figaro::Tasks
  describe Heroku do
    subject(:heroku) { Heroku.new }

    describe "#invoke" do
      it "configures Heroku" do
        heroku.stub(:vars => "FOO=bar")

        heroku.should_receive(:heroku).once.with("config:set FOO=bar")

        heroku.invoke
      end
    end

    describe "#vars" do
      it "returns Figaro's vars for Heroku's environment" do
        heroku.stub(:environment => "staging")
        Figaro.stub(:vars).with("staging").and_return("FOO=bar")

        expect(heroku.vars).to eq("FOO=bar")
      end
    end

    describe "#environment" do
      it "returns Heroku's environment" do
        heroku.stub(:heroku).with("run 'echo $RAILS_ENV'").and_return(<<-OUT)
Running `echo $RAILS_ENV` attached to terminal... up, run.1234
staging
OUT

        expect(heroku.environment).to eq("staging")
      end
    end

    describe "#heroku" do
      it "runs a command on Heroku" do
        heroku.should_receive(:`).once.with("heroku info")

        heroku.heroku("info")
      end

      it "runs a command on a specific Heroku app" do
        heroku = Heroku.new("my-app")

        heroku.should_receive(:`).once.with("heroku info --app my-app")

        heroku.heroku("info")
      end
    end
  end

  describe "figaro:heroku", :rake => true do
    subject(:heroku) { mock(:heroku) }

    it "configures Heroku" do
      Figaro::Tasks::Heroku.stub(:new).with(nil).and_return(heroku)
      heroku.should_receive(:invoke).once

      task.invoke
    end

    it "configures a specific Heroku app" do
      Figaro::Tasks::Heroku.stub(:new).with("my-app").and_return(heroku)
      heroku.should_receive(:invoke).once

      task.invoke("my-app")
    end
  end
end
