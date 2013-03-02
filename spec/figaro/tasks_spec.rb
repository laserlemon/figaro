require "spec_helper"

describe Figaro::Tasks do
  describe ".heroku" do
    it "configures Heroku" do
      Figaro.stub(:vars => "FOO=bar")

      Figaro::Tasks.should_receive(:`).once.with('heroku run "echo \$RAILS_ENV"').
        and_return("\ndevelopment\n")
      Figaro::Tasks.should_receive(:`).once.with("heroku config:add FOO=bar")

      Figaro::Tasks.heroku
    end

    it "configures a specific Heroku app" do
      Figaro.stub(:vars => "FOO=bar")

      Figaro::Tasks.should_receive(:`).once.
        with('heroku run "echo \$RAILS_ENV"').
        and_return("\ndevelopment\n")
      Figaro::Tasks.should_receive(:`).once.
        with("heroku config:add FOO=bar --app my-app")

      Figaro::Tasks.heroku("my-app")
    end

    it "respects the Heroku's remote Rails environment" do
      Figaro::Tasks.stub(:`).with('heroku run "echo \$RAILS_ENV"').
        and_return("\nproduction\n")

      Figaro.should_receive(:vars).once.with("production").and_return("FOO=bar")
      Figaro::Tasks.should_receive(:`).once.with("heroku config:add FOO=bar")

      Figaro::Tasks.heroku
    end

    it "defaults to the local Rails environment if not set remotely" do
      Figaro::Tasks.stub(:`).with('heroku run "echo \$RAILS_ENV"').
        and_return("\n\n")

      Figaro.should_receive(:vars).once.with(nil).and_return("FOO=bar")
      Figaro::Tasks.should_receive(:`).once.with("heroku config:add FOO=bar")

      Figaro::Tasks.heroku
    end

    describe "figaro:heroku", :rake => true do
      it "configures Heroku" do
        Figaro::Tasks.should_receive(:heroku).once.with(nil)

        task.invoke
      end

      it "configures a specific Heroku app" do
        Figaro::Tasks.should_receive(:heroku).once.with("my-app")

        task.invoke("my-app")
      end
    end
  end
end
