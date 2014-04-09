require "spec_helper"

require "tempfile"

module Figaro
  describe Application do
    before do
      Application.any_instance.stub(
        default_path: "/path/to/app/config/application.yml",
        default_environment: "development"
      )
    end

    describe "#path" do
      it "uses the default" do
        application = Application.new

        expect(application.path).to eq("/path/to/app/config/application.yml")
      end

      it "is configurable via initialization" do
        application = Application.new(path: "/app/env.yml")

        expect(application.path).to eq("/app/env.yml")
      end

      it "is configurable via setter" do
        application = Application.new
        application.path = "/app/env.yml"

        expect(application.path).to eq("/app/env.yml")
      end

      it "casts to string" do
        application = Application.new(path: Pathname.new("/app/env.yml"))

        expect(application.path).to eq("/app/env.yml")
        expect(application.environment).not_to be_a(Pathname)
      end

      it "follows a changing default" do
        application = Application.new

        expect {
          application.stub(default_path: "/app/env.yml")
        }.to change {
          application.path
        }.from("/path/to/app/config/application.yml").to("/app/env.yml")
      end
    end

    describe "#environment" do
      it "uses the default" do
        application = Application.new

        expect(application.environment).to eq("development")
      end

      it "is configurable via initialization" do
        application = Application.new(environment: "test")

        expect(application.environment).to eq("test")
      end

      it "is configurable via setter" do
        application = Application.new
        application.environment = "test"

        expect(application.environment).to eq("test")
      end

      it "casts to string" do
        application = Application.new(environment: :test)

        expect(application.environment).to eq("test")
        expect(application.environment).not_to be_a(Symbol)
      end

      it "follows a changing default" do
        application = Application.new

        expect {
          application.stub(default_environment: "test")
        }.to change {
          application.environment
        }.from("development").to("test")
      end
    end

    describe "#configuration" do
      def yaml_to_path(yaml)
        Tempfile.open("figaro") do |file|
          file.write(yaml)
          file.path
        end
      end

      it "loads values from YAML" do
        application = Application.new(path: yaml_to_path(<<-YAML))
foo: bar
YAML

        expect(application.configuration).to eq("foo" => "bar")
      end

      it "merges environment-specific values" do
        application = Application.new(path: yaml_to_path(<<-YAML), environment: "test")
foo: bar
test:
  foo: baz
YAML

        expect(application.configuration).to eq("foo" => "baz")
      end

      it "drops unused environment-specific values" do
        application = Application.new(path: yaml_to_path(<<-YAML), environment: "test")
foo: bar
test:
  foo: baz
production:
  foo: bad
YAML

        expect(application.configuration).to eq("foo" => "baz")
      end

      it "is empty when no YAML file is present" do
        application = Application.new(path: "/path/to/nowhere")

        expect(application.configuration).to eq({})
      end

      it "is empty when the YAML file is blank" do
        application = Application.new(path: yaml_to_path(""))

        expect(application.configuration).to eq({})
      end

      it "is empty when the YAML file contains only comments" do
        application = Application.new(path: yaml_to_path(<<-YAML))
# Comment
YAML

        expect(application.configuration).to eq({})
      end

      it "processes ERB" do
        application = Application.new(path: yaml_to_path(<<-YAML))
foo: <%= "bar".upcase %>
YAML

        expect(application.configuration).to eq("foo" => "BAR")
      end

      it "follows a changing default path" do
        path_1 = yaml_to_path("foo: bar")
        path_2 = yaml_to_path("foo: baz")

        application = Application.new
        application.stub(default_path: path_1)

        expect {
          application.stub(default_path: path_2)
        }.to change {
          application.configuration
        }.from("foo" => "bar").to("foo" => "baz")
      end

      it "follows a changing default environment" do
        application = Application.new(path: yaml_to_path(<<-YAML))
foo: bar
test:
  foo: baz
YAML
        application.stub(default_environment: "development")

        expect {
          application.stub(default_environment: "test")
        }.to change {
          application.configuration
        }.from("foo" => "bar").to("foo" => "baz")
      end
    end

    describe "#load" do
      let!(:application) { Application.new }

      before do
        ::ENV.delete("foo")
        ::ENV.delete("_FIGARO_foo")

        application.stub(configuration: { "foo" => "bar" })
      end

      it "merges values into ENV" do
        expect {
          application.load
        }.to change {
          ::ENV["foo"]
        }.from(nil).to("bar")
      end

      it "skips keys that have already been set externally" do
        ::ENV["foo"] = "baz"

        expect {
          application.load
        }.not_to change {
          ::ENV["foo"]
        }
      end

      it "sets keys that have already been set internally" do
        application.load

        application.stub(configuration: { "foo" => "baz" })

        expect {
          application.load
        }.to change {
          ::ENV["foo"]
        }.from("bar").to("baz")
      end

      it "warns when a key isn't a string" do
        application.stub(configuration: { foo: "bar" })

        expect(application).to receive(:warn).once

        application.load
      end

      it "warns when a value isn't a string" do
        application.stub(configuration: { "foo" => ["bar"] })

        expect(application).to receive(:warn).once

        application.load
      end
    end
  end
end
