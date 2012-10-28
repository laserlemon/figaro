require "spec_helper"

describe Figaro do
  describe ".env" do
    it "makes ENV values accessible" do
      ENV["HELLO"] = "world"
      Figaro.stub(:raw => {})
      Figaro.env.hello.should == "world"
      ENV.delete("HELLO")
    end
  end
end
