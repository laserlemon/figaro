module Figaro
  module Rails
    describe Application do
      describe "#default_path" do
        let!(:application) { Application.new }

        before { allow(::Rails).to receive(:root) { Pathname.new("/path/to/app") } }

        it "defaults to config/application.yml in Rails.root" do
          expect {
            allow(::Rails).to receive(:root) { Pathname.new("/app") }
          }.to change {
            application.send(:default_path).to_s
          }.from("/path/to/app/config/application.yml").to("/app/config/application.yml")
        end

        it "defaults to path relative to Rails.root from the FIGARO_PATH environment variable" do
          expect {
            ::ENV["FIGARO_PATH"] = "./config/application.docker.yml"
          }.to change {
            application.send(:default_path).to_s
          }.from("/path/to/app/config/application.yml").to("/path/to/app/config/application.docker.yml")
          ::ENV["FIGARO_PATH"] = nil
        end

        it "defaults to absolute path from the FIGARO_PATH environment variable" do
          expect {
            ::ENV["FIGARO_PATH"] = "/var/config/my-app.yml"
          }.to change {
            application.send(:default_path).to_s
          }.from("/path/to/app/config/application.yml").to("/var/config/my-app.yml")
          ::ENV["FIGARO_PATH"] = nil
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
