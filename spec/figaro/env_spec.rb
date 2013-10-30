require "spec_helper"

describe Figaro::ENV do
  subject(:env) { Figaro::ENV }

  before do
    ENV["HELLO"] = "world"
    ENV["foo"] = "bar"
  end

  after do
    ENV.delete("HELLO")
    ENV.delete("foo")
  end

  describe '#required_keys!' do
    context 'when all keys are present' do
      it 'raises no exceptions' do
        expect{env.required_keys!(:hello, :foo)}.to_not raise_error(Figaro::MissingKey)
      end

      it 'handles plain strings' do
        expect{env.required_keys!('hello', 'foo')}.to_not raise_error(Figaro::MissingKey)
      end
    end

    context 'when missing keys' do
      it 'raises MissingKey exception' do
        expect{env.required_keys!(:hello, :baz)}.to raise_error(Figaro::MissingKey)
      end

      it 'emits all missing keys in error message' do
        expect{env.required_keys!(:hello, :baz, :qux)}.to raise_error(Figaro::MissingKey, /BAZ, QUX/)
      end
    end
  end

  describe "#method_missing" do
    context "plain methods" do
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

      it "returns nil if no ENV key matches" do
        expect(env.goodbye).to eq(nil)
      end
    end

    context "bang methods" do
      it "makes ENV values accessible as lowercase methods" do
        expect(env.hello!).to eq("world")
        expect(env.foo!).to eq("bar")
      end

      it "makes ENV values accessible as uppercase methods" do
        expect(env.HELLO!).to eq("world")
        expect(env.FOO!).to eq("bar")
      end

      it "makes ENV values accessible as mixed-case methods" do
        expect(env.Hello!).to eq("world")
        expect(env.fOO!).to eq("bar")
      end

      it "raises an error if no ENV key matches" do
        expect { env.goodbye! }.to raise_error(Figaro::MissingKey)
      end
    end

    context "boolean methods" do
      it "returns true for accessible, lowercase methods" do
        expect(env.hello?).to eq(true)
        expect(env.foo?).to eq(true)
      end

      it "returns true for accessible, uppercase methods" do
        expect(env.HELLO?).to eq(true)
        expect(env.FOO?).to eq(true)
      end

      it "returns true for accessible, mixed-case methods" do
        expect(env.Hello?).to eq(true)
        expect(env.fOO?).to eq(true)
      end

      it "returns false if no ENV key matches" do
        expect(env.goodbye?).to eq(false)
      end
    end

    context "setter methods" do
      it "raises an error" do
        expect { env.foo = "bar" }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#respond_to?" do
    context "plain methods" do
      context "when ENV has the key" do
        it "is true for a lowercase method" do
          expect(env.respond_to?(:hello)).to eq(true)
          expect(env.respond_to?(:foo)).to eq(true)
        end

        it "is true for a uppercase method" do
          expect(env.respond_to?(:HELLO)).to eq(true)
          expect(env.respond_to?(:FOO)).to eq(true)
        end

        it "is true for a mixed-case key" do
          expect(env.respond_to?(:Hello)).to eq(true)
          expect(env.respond_to?(:fOO)).to eq(true)
        end
      end

      context "when ENV doesn't have the key" do
        it "is true" do
          expect(env.respond_to?(:baz)).to eq(true)
        end
      end
    end

    context "bang methods" do
      context "when ENV has the key" do
        it "is true for a lowercase method" do
          expect(env.respond_to?(:hello!)).to eq(true)
          expect(env.respond_to?(:foo!)).to eq(true)
        end

        it "is true for a uppercase method" do
          expect(env.respond_to?(:HELLO!)).to eq(true)
          expect(env.respond_to?(:FOO!)).to eq(true)
        end

        it "is true for a mixed-case key" do
          expect(env.respond_to?(:Hello!)).to eq(true)
          expect(env.respond_to?(:fOO!)).to eq(true)
        end
      end

      context "when ENV doesn't have the key" do
        it "is false" do
          expect(env.respond_to?(:baz!)).to eq(false)
        end
      end
    end

    context "boolean methods" do
      context "when ENV has the key" do
        it "is true for a lowercase method" do
          expect(env.respond_to?(:hello?)).to eq(true)
          expect(env.respond_to?(:foo?)).to eq(true)
        end

        it "is true for a uppercase method" do
          expect(env.respond_to?(:HELLO?)).to eq(true)
          expect(env.respond_to?(:FOO?)).to eq(true)
        end

        it "is true for a mixed-case key" do
          expect(env.respond_to?(:Hello?)).to eq(true)
          expect(env.respond_to?(:fOO?)).to eq(true)
        end
      end

      context "when ENV doesn't have the key" do
        it "is true" do
          expect(env.respond_to?(:baz?)).to eq(true)
        end
      end
    end

    context "setter methods" do
      context "when ENV has the key" do
        it "is false" do
          expect(env.respond_to?(:foo=)).to eq(false)
        end
      end

      context "when ENV doesn't have the key" do
        it "is false" do
          expect(env.respond_to?(:baz=)).to eq(false)
        end
      end
    end
  end
end
