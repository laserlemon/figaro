require "spec_helper"

describe Figaro do
  describe ".vars" do
    it "dumps and sorts env" do
      Figaro.stub(:env => Figaro::Env.from("HELLO" => "world", "FOO" => "bar"))

      Figaro.vars.should == "FOO=bar HELLO=world"
    end

    it "allows access to a particular environment" do
      Figaro.stub(:env).with("development")
        .and_return(Figaro::Env.from("HELLO" => "developers"))
      Figaro.stub(:env).with("production")
        .and_return(Figaro::Env.from("HELLO" => "world"))

      Figaro.vars("development").should == "HELLO=developers"
      Figaro.vars("production").should == "HELLO=world"
    end
  end

  describe ".env" do
    it "is a Figaro env instance" do
      Figaro.stub(:raw => {"FOO" => "bar"})

      Figaro.env.should be_a(Figaro::Env)
    end

    it "allows access to a particular environment" do
      Figaro.stub(:raw).and_return(
        "development" => {"HELLO" => "developers"},
        "production" => {"HELLO" => "world"}
      )

      Figaro.env(:development).should == {"HELLO" => "developers"}
      Figaro.env(:production).should == {"HELLO" => "world"}
    end

    it "stringifies keys and values" do
      Figaro.stub(:raw).and_return(:LUFTBALLOONS => 99)

      Figaro.env.should == {"LUFTBALLOONS" => "99"}
    end
  end
end
