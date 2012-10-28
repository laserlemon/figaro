require "spec_helper"

describe Figaro do
  describe ".vars" do
    it "dumps and sorts env" do
      Figaro.stub(:raw => {"HELLO" => "world", "FOO" => "bar"})
      Figaro.vars.should == "FOO=bar HELLO=world"
    end

    it "allows access to a particular environment" do
      Figaro.stub(:raw => {"development" => {"HELLO" => "developers"}, "production" => {"HELLO" => "world"}})
      Figaro.vars(:development).should == "HELLO=developers"
      Figaro.vars(:production).should == "HELLO=world"
    end
  end

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
