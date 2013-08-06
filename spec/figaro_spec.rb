require "spec_helper"

describe Figaro do
  describe ".env" do
    it "falls through to Figaro::ENV" do
      expect(Figaro.env).to eq(Figaro::ENV)
    end
  end
end
