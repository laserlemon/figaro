require "spec_helper"

module Figaro
  module Rails
    describe Application do
      describe "#default_path" do
        let!(:application) { Application.new }

        it "defaults to config/application.yml in Rails.root" do
          ::Rails.stub(root: Pathname.new("/path/to/app"))

          expect {
            ::Rails.stub(root: Pathname.new("/app"))
          }.to change {
            application.send(:default_path).to_s
          }.from("/path/to/app/config/application.yml").to("/app/config/application.yml")
        end

        it "can be overridden with FIGARO_CONFIG ENV var" do
          ::Rails.stub(root: Pathname.new("/path/to/app"))

          expect {
            ::ENV.stub(:[]).with("FIGARO_CONFIG").and_return("/etc/app/application.yml")
          }.to change {
            application.send(:default_path).to_s
          }.from("/path/to/app/config/application.yml").to("/etc/app/application.yml")
        end

        it "raises an error when Rails.root isn't set yet" do
          ::Rails.stub(root: nil)

          expect {
            application.send(:default_path)
          }.to raise_error(RailsNotInitialized)
        end
      end

      describe "#default_environment" do
        let!(:application) { Application.new }

        it "defaults to Rails.env" do
          ::Rails.stub(env: "development")

          expect {
            ::Rails.stub(env: "test")
          }.to change {
            application.send(:default_environment).to_s
          }.from("development").to("test")
        end
      end
    end
  end
end
