require "spec_helper"

describe Figaro do
  describe ".version" do
    it "exists" do
      expect(Figaro).to respond_to(:version)
      expect(Figaro.version).to be_a(Gem::Version)
    end
  end
end
