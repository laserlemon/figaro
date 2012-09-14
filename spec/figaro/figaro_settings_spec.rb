require "spec_helper"

describe FigaroSettings do
  it "retrieves values from the environment" do
    ENV['some_key'] = 'some value'
    FigaroSettings.some_key.should == 'some value'
  end
end
