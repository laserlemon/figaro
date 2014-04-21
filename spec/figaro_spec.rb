require "spec_helper"

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
      Figaro.stub(:adapter) { adapter }
      adapter.stub(:new).with(no_args) { application }
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
      Figaro.stub(:application) { application }
    end

    it "loads the application configuration" do
      expect(application).to receive(:load).once.with(no_args)

      Figaro.load
    end
  end

  describe ".require" do
    before do
      ::ENV["foo"] = "bar"
      ::ENV["hello"] = "world"
    end

    context "called with an array" do
      context "when no keys are missing" do
        it "does nothing" do
          expect {
            Figaro.require("foo", "hello")
          }.not_to raise_error
        end
      end

      context "when keys are missing" do
        it "raises an error for the missing keys" do
          expect {
            Figaro.require("foo", "goodbye", "baz")
          }.to raise_error(Figaro::MissingKeys) { |error|
            expect(error.message).not_to include("foo")
            expect(error.message).to include("goodbye")
            expect(error.message).to include("baz")
          }
        end
      end
    end

    context "called with a hash" do
      context "when no keys are missing" do
        it "does nothing" do
          expect {
            Figaro.require(foo: 'foo explained', hello: 'hello explained')
          }.not_to raise_error
        end
      end

      context "when keys are missing" do
        it "raises an error for the missing keys including explanations" do
          expect {
            Figaro.require(foo: 'foo explained', goodbye: 'goodbye explained', baz: 'baz explained')
          }.to raise_error(Figaro::MissingKeys) { |error|
            expect(error.message).not_to include("foo")
            expect(error.message).to include("- goodbye: goodbye explained")
            expect(error.message).to include("- baz: baz explained")
          }
        end
      end
    end
  end
end
