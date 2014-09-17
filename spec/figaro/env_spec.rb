describe Figaro::ENV do
  subject(:env) { Figaro::ENV }

  before do
    ::ENV["HELLO"] = "world"
    ::ENV["foo"] = "bar"
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

      it "respects a stubbed plain method" do
        allow(env).to receive(:bar) { "baz" }
        expect(env.bar).to eq("baz")
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

      it "respects a stubbed plain method" do
        allow(env).to receive(:bar) { "baz" }
        expect { expect(env.bar!).to eq("baz") }.not_to raise_error
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

      it "respects a stubbed plain method" do
        allow(env).to receive(:bar) { "baz" }
        expect(env.bar?).to eq(true)
      end
    end

    context "setter methods" do
      it "raises an error for accessible, lowercase methods" do
        expect { env.hello = "world" }.to raise_error(NoMethodError)
        expect { env.foo = "bar" }.to raise_error(NoMethodError)
      end

      it "raises an error for accessible, uppercase methods" do
        expect { env.HELLO = "world" }.to raise_error(NoMethodError)
        expect { env.FOO = "bar" }.to raise_error(NoMethodError)
      end

      it "raises an error for accessible, mixed-case methods" do
        expect { env.Hello = "world" }.to raise_error(NoMethodError)
        expect { env.fOO = "bar" }.to raise_error(NoMethodError)
      end

      it "raises an error if no ENV key matches" do
        expect { env.goodbye = "world" }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#respond_to?" do
    context "plain methods" do
      it "returns true for accessible, lowercase methods" do
        expect(env.respond_to?(:hello)).to eq(true)
        expect(env.respond_to?(:foo)).to eq(true)
      end

      it "returns true for accessible uppercase methods" do
        expect(env.respond_to?(:HELLO)).to eq(true)
        expect(env.respond_to?(:FOO)).to eq(true)
      end

      it "returns true for accessible mixed-case methods" do
        expect(env.respond_to?(:Hello)).to eq(true)
        expect(env.respond_to?(:fOO)).to eq(true)
      end

      it "returns true if no ENV key matches" do
        expect(env.respond_to?(:baz)).to eq(true)
      end
    end

    context "bang methods" do
      it "returns true for accessible, lowercase methods" do
        expect(env.respond_to?(:hello!)).to eq(true)
        expect(env.respond_to?(:foo!)).to eq(true)
      end

      it "returns true for accessible uppercase methods" do
        expect(env.respond_to?(:HELLO!)).to eq(true)
        expect(env.respond_to?(:FOO!)).to eq(true)
      end

      it "returns true for accessible mixed-case methods" do
        expect(env.respond_to?(:Hello!)).to eq(true)
        expect(env.respond_to?(:fOO!)).to eq(true)
      end

      it "returns false if no ENV key matches" do
        expect(env.respond_to?(:baz!)).to eq(false)
      end
    end

    context "boolean methods" do
      it "returns true for accessible, lowercase methods" do
        expect(env.respond_to?(:hello?)).to eq(true)
        expect(env.respond_to?(:foo?)).to eq(true)
      end

      it "returns true for accessible uppercase methods" do
        expect(env.respond_to?(:HELLO?)).to eq(true)
        expect(env.respond_to?(:FOO?)).to eq(true)
      end

      it "returns true for accessible mixed-case methods" do
        expect(env.respond_to?(:Hello?)).to eq(true)
        expect(env.respond_to?(:fOO?)).to eq(true)
      end

      it "returns true if no ENV key matches" do
        expect(env.respond_to?(:baz?)).to eq(true)
      end
    end

    context "setter methods" do
      it "returns false for accessible, lowercase methods" do
        expect(env.respond_to?(:hello=)).to eq(false)
        expect(env.respond_to?(:foo=)).to eq(false)
      end

      it "returns false for accessible uppercase methods" do
        expect(env.respond_to?(:HELLO=)).to eq(false)
        expect(env.respond_to?(:FOO=)).to eq(false)
      end

      it "returns false for accessible mixed-case methods" do
        expect(env.respond_to?(:Hello=)).to eq(false)
        expect(env.respond_to?(:fOO=)).to eq(false)
      end

      it "returns false if no ENV key matches" do
        expect(env.respond_to?(:baz=)).to eq(false)
      end
    end
  end
end
