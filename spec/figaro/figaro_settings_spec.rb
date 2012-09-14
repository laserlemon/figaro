require "spec_helper"

describe FigaroSettings do
  it "retrieves values from the environment" do
    ENV['SOME_KEY'] = 'some value'
    FigaroSettings.SOME_KEY.should == 'some value'
  end

  it "retrieves the value of the upcased version of the key" do
    ENV['SOME_KEY'] = 'some value'
    FigaroSettings.some_key.should == 'some value'
  end

  it "responds to any method where an environment variable of the same name exists" do
    FigaroSettings.respond_to?(:another_key).should be_false
    ENV['ANOTHER_KEY'] = 'another value'
    FigaroSettings.respond_to?(:another_key).should be_true
  end

  it "raises an error if it can't find a key" do
    expect do
      FigaroSettings.yet_another_key
    end.to raise_error(FigaroSettings::SettingNotFoundError)
  end
end
