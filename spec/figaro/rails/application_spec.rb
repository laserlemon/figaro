module Figaro
  module Rails
    describe Application do
      describe "#default_path" do
        let!(:application) { Application.new }

        it "defaults to config/application.yml in Rails.root" do
          allow(::Rails).to receive(:root) { Pathname.new("/path/to/app") }

          expect {
            allow(::Rails).to receive(:root) { Pathname.new("/app") }
          }.to change {
            application.send(:default_path).to_s
          }.from("/path/to/app/config/application.yml").to("/app/config/application.yml")
        end

        it "raises an error when Rails.root isn't set yet" do
          allow(::Rails).to receive(:root) { nil }

          expect {
            application.send(:default_path)
          }.to raise_error(RailsNotInitialized)
        end
      end

      describe "#default_environment" do
        let!(:application) { Application.new }

        it "defaults to Rails.env" do
          allow(::Rails).to receive(:env) { "development" }

          expect {
            allow(::Rails).to receive(:env) { "test" }
          }.to change {
            application.send(:default_environment).to_s
          }.from("development").to("test")
        end
      end
    end
  end
end
