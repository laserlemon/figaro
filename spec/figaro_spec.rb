# frozen_string_literal: true

require "spec_helper"

describe Figaro do
  describe ".version" do
    it "exists" do
      expect(Figaro).to respond_to(:version)
      expect(Figaro.version).to be_a(Gem::Version)
    end
  end

  describe ".config" do
    it "loads and memoizes the Figaro config" do
      config = double
      expect(Figaro::Config).to receive(:load).with(no_args).and_return(config)

      expect(Figaro.config).to eq(config)
      expect(Figaro.config).to eq(config)
    end
  end
end
