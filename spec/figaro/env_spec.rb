require "spec_helper"

describe Figaro::Env do
  subject(:env) { Figaro::Env.new }

  before do
    ENV["HELLO"] = "world"
    ENV["foo"] = "bar"
  end

  after do
    ENV.delete("HELLO")
    ENV.delete("foo")
  end

  describe "#method_missing" do
    it "makes ENV values accessible as lowercase methods" do
      expect(env.hello).to eq("world")
      expect(env.foo).to eq("bar")
    end

    it "makes ENV values accessible as uppercase methods" do
      expect(env.HELLO).to eq("world")
      expect(env.FOO).to eq("bar")
    end

    it "makes ENV values accessible as mixed-case methods" do
      expect(env.Hello).to eq("world")
      expect(env.fOO).to eq("bar")
    end

    it "raises an error if no ENV key matches" do
      expect { env.goodbye }.to raise_error(NoMethodError)
    end
  end

  describe "#respond_to?" do
    context "when ENV has the key" do
      it "is true for a lowercase method" do
        expect(env.respond_to?(:hello)).to be_true
        expect(env.respond_to?(:foo)).to be_true
      end

      it "is true for a uppercase method" do
        expect(env.respond_to?(:HELLO)).to be_true
        expect(env.respond_to?(:FOO)).to be_true
      end

      it "is true for a mixed-case key" do
        expect(env.respond_to?(:Hello)).to be_true
        expect(env.respond_to?(:fOO)).to be_true
      end
    end

    context "when ENV doesn't have the key" do
      it "is true if Hash responds to the method" do
        expect(env.respond_to?(:baz)).to be_false
      end

      it "is false if Hash doesn't respond to the method" do
        expect(env.respond_to?(:[])).to be_true
      end
    end
  end
end
