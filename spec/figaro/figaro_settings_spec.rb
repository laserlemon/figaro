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

  it "should return the new value if environment is changed" do
    ENV['SOME_KEY'] = 'some value'
    FigaroSettings.some_key.should == 'some value'
    ENV['SOME_KEY'] = 'some new value'
    FigaroSettings.some_key.should == 'some new value'
  end

  it "responds to any method where an environment variable of the same name exists" do
    FigaroSettings.respond_to?(:another_key).should be_false
    ENV['ANOTHER_KEY'] = 'another value'
    FigaroSettings.respond_to?(:another_key).should be_true
  end

  it "retrieves nil if it cannot find the key" do
    FigaroSettings.some_key_not_there.nil?.should be_true
  end

  it "raises an error if it can't find a key using bang" do
    expect do
      FigaroSettings.yet_another_key!
    end.to raise_error(FigaroSettings::SettingNotFoundError)
  end

  it "finds the value from java system property if using jruby" do
    if RUBY_ENGINE == "jruby"
      java.lang.System.set_property 'test_prop', 'test_val'
      FigaroSettings.test_prop.should == 'test_val'
      java.lang.System.set_property 'test_prop', 'test_val2'
      FigaroSettings.test_prop.should == 'test_val2'
    end
  end
end