require "spec_helper"

describe "Figaro Rake tasks", :rake => true do
  describe "figaro:heroku" do

    it "configures Heroku" do
      configure_heroku = Figaro::ConfigureHeroku.new
      Figaro::ConfigureHeroku.stub(:new).and_return(configure_heroku)
      configure_heroku.should_receive(:execute)
      task.invoke
    end

  end
end