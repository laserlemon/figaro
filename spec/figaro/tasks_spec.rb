require "spec_helper"

module Figaro::Tasks
  describe Heroku do
    subject(:heroku) { Heroku.new }

    let(:file) { "../../LICENSE" }
    let(:stringio) { StringIO.new("line of text") }

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

    describe "#pull" do
      before { heroku.stub(:config => file) }
      it "writes Heroku's output to a file" do
        heroku.should_receive(:pulled_vars).once

        heroku.pull
      end

      it "opens a file" do
        heroku.should_receive(:config).once

        heroku.pull
      end
    end

    describe "#pulled_vars" do
      before { heroku.stub(:heroku => "key: value") }
      it "stores Heroku's output in a StringIO object" do
        heroku.should_receive(:heroku).once.with("config")

        heroku.pulled_vars
      end

      it "parses Heroku's output" do
        heroku.should_receive(:parse).with(kind_of(StringIO))

        heroku.pulled_vars
      end
    end

    describe "#parse" do
      it "analyzes each line of Heroku's output" do
        heroku.should_receive(:filter).with("line of text", '')

        heroku.parse(stringio)
      end

      it "returns a string" do
        expect(heroku.parse(stringio)).to be_a String
      end
    end

    describe "#filter" do
      let(:str) { "" }
      context "given lines containing a database URL" do
        it "does not collect it" do
          heroku.filter("postgres://etcetc", str)

          str.should eq ''
        end
      end

      context "given lines containing Heroku's heading" do
        it "does not collect it" do
          heroku.filter("tranquil-ridge-8875 Config Vars", str)

          str.should eq ''
        end
      end

      context "given lines containing key/value pairs" do
        it "does collect it" do
          heroku.filter("API_KEY: abc457na3g9", str)

          str.should eq "API_KEY: abc457na3g9"
        end
      end
    end

    describe "#config" do
      it "returns path to a Rails project's application.yml" do
        Rails.stub(:root => Pathname.new("/home/app"))

        expect(heroku.config.to_s).to eq '/home/app/config/application.yml'
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

  describe "figaro:pull", :rake => true do
    subject(:heroku) { mock(:heroku) }

    it "appends Heroku's vars to application.yml" do
      Figaro::Tasks::Heroku.stub(:new).with(nil).and_return(heroku)
      heroku.should_receive(:pull).once

      task.invoke
    end
  end
end