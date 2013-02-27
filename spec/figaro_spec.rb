require "spec_helper"

describe Figaro do
  describe ".vars" do
    it "dumps and sorts env" do
      Figaro.stub(:env => Figaro::Env.from("HELLO" => "world", "FOO" => "bar"))

      expect(Figaro.vars).to eq("FOO=bar HELLO=world")
    end

    it "allows access to a particular environment" do
      Figaro.stub(:env).with("development").
        and_return(Figaro::Env.from("HELLO" => "developers"))
      Figaro.stub(:env).with("production").
        and_return(Figaro::Env.from("HELLO" => "world"))

      expect(Figaro.vars("development")).to eq("HELLO=developers")
      expect(Figaro.vars("production")).to eq("HELLO=world")
    end

    it "escapes special characters" do
      Figaro.stub(:env => Figaro::Env.from("FOO" => "bar baz"))

      expect(Figaro.vars).to eq('FOO=bar\ baz')
    end
  end

  describe ".env" do
    it "is a Figaro env instance" do
      Figaro.stub(:raw => { "FOO" => "bar" })

      expect(Figaro.env).to be_a(Figaro::Env)
    end

    it "allows access to a particular environment" do
      Figaro.stub(:raw).and_return(
        "development" => { "HELLO" => "developers" },
        "production" => { "HELLO" => "world" }
      )

      expect(Figaro.env(:development)).to eq("HELLO" => "developers")
      expect(Figaro.env(:production)).to eq("HELLO" => "world")
    end

    it "stringifies keys and values" do
      Figaro.stub(:raw => { :LUFTBALLOONS => 99 })

      expect(Figaro.env).to eq("LUFTBALLOONS" => "99")
    end

    it "allows nil values" do
      Figaro.stub(:raw => { "FOO" => nil })

      expect(Figaro.env).to eq("FOO" => nil)
    end

    it "casts booleans to strings" do
      Figaro.stub(:raw => { "FOO" => true, "BAR" => false })

      expect(Figaro.env).to eq("FOO" => "true", "BAR" => "false")
    end
  end
end
