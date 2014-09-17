describe Figaro do
  describe ".env" do
    it "falls through to Figaro::ENV" do
      expect(Figaro.env).to eq(Figaro::ENV)
    end
  end

  describe ".adapter" do
    let(:adapter) { double(:adapter) }

    it "defaults to the generic application adapter" do
      expect(Figaro.adapter).to eq(Figaro::Application)
    end

    it "is configurable" do
      expect {
        Figaro.adapter = adapter
      }.to change {
        Figaro.adapter
      }.from(Figaro::Application).to(adapter)
    end
  end

  describe ".application" do
    let(:adapter) { double(:adapter) }
    let(:application) { double(:application) }
    let(:custom_application) { double(:custom_application) }

    before do
      allow(Figaro).to receive(:adapter) { adapter }
      allow(adapter).to receive(:new).with(no_args) { application }
    end

    it "defaults to a new adapter application" do
      expect(Figaro.application).to eq(application)
    end

    it "is configurable" do
      expect {
        Figaro.application = custom_application
      }.to change {
        Figaro.application
      }.from(application).to(custom_application)
    end
  end

  describe ".load" do
    let(:application) { double(:application) }

    before do
      allow(Figaro).to receive(:application) { application }
    end

    it "loads the application configuration" do
      expect(application).to receive(:load).once.with(no_args)

      Figaro.load
    end
  end

  describe ".require_keys" do
    before do
      ::ENV["foo"] = "bar"
      ::ENV["hello"] = "world"
    end

    context "when no keys are missing" do
      it "does nothing" do
        expect {
          Figaro.require_keys("foo", "hello")
        }.not_to raise_error
      end

      it "accepts an array" do
        expect {
          Figaro.require_keys(["foo", "hello"])
        }.not_to raise_error
      end
    end

    context "when keys are missing" do
      it "raises an error for the missing keys" do
        expect {
          Figaro.require_keys("foo", "goodbye", "baz")
        }.to raise_error(Figaro::MissingKeys) { |error|
          expect(error.message).not_to include("foo")
          expect(error.message).to include("goodbye")
          expect(error.message).to include("baz")
        }
      end

      it "accepts an array" do
        expect {
          Figaro.require_keys(["foo", "goodbye", "baz"])
        }.to raise_error(Figaro::MissingKeys)
      end
    end
  end
end
