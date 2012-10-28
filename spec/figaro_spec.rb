require "spec_helper"

describe Figaro do
  describe ".env" do
    it "makes ENV values accessible" do
      ENV["HELLO"] = "world"
      Figaro.stub(:raw => {})
      Figaro.env.hello.should == "world"
      ENV.delete("HELLO")
    end

    it "allows access to a particular environment" do
      Figaro.stub(:raw => {"development" => {"HELLO" => "developers"}, "production" => {"HELLO" => "world"}})
      Figaro.env(:development).should == {"HELLO" => "developers"}
      Figaro.env(:production).should == {"HELLO" => "world"}
    end
  end
end
