require "spec_helper"

module Figaro
  describe Config do
    describe ".load" do
      context "string" do
        it "loads a set string variable" do
          ENV["FOO"] = "bar"
          write_envfile <<-EOF
            string :foo
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq("bar")
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("bar")
        end

        it "loads an unset string variable with a default value" do
          write_envfile <<-EOF
            string :foo, default: "bar"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq("bar")
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("bar")
        end

        it "loads a set string variable with a default value" do
          ENV["FOO"] = "baz"
          write_envfile <<-EOF
            string :foo, default: "bar"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq("baz")
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("baz")
        end

        it "raises an error if an unset string variable is required" do
          write_envfile <<-EOF
            string :foo
            EOF

          expect { Figaro::Config.load }.to raise_error(Figaro::Error)
        end

        it "loads an optional, unset string variable" do
          write_envfile <<-EOF
            string :foo, required: false
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(nil)
          expect(config.foo?).to eq(false)
          expect(ENV["FOO"]).to eq(nil)
        end

        it "loads an unset string variable when dynamically optional" do
          write_envfile <<-EOF
            string :foo, required: false
            string :bar, required: -> { foo? }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to eq(nil)
          expect(config.bar?).to eq(false)
          expect(ENV["BAR"]).to eq(nil)
        end

        it "loads an string variable from a custom ENV key" do
          ENV["FU"] = "bar"
          write_envfile <<-EOF
            string :foo, key: "FU"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq("bar")
          expect(config.foo?).to eq(true)
          expect(ENV["FU"]).to eq("bar")
        end

        # TODO: Decide whether an empty string should be considered as "set."
        it "loads an empty string" do
          ENV["FOO"] = ""
          write_envfile <<-EOF
            string :foo
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq("")
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("")
        end

        it "loads a string variable with a dynamically set default value" do
          ENV["FOO"] = "bar"
          write_envfile <<-EOF
            string :foo
            string :bar, default: -> { foo }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to eq("bar")
          expect(config.bar?).to eq(true)
          expect(ENV["BAR"]).to eq("bar")
        end

        it "loads a string variable with a non-string default value" do
          write_envfile <<-EOF
            string :foo, default: 1
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq("1")
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("1")
        end
      end

      context "integer" do
        it "loads a set integer variable" do
          ENV["FOO"] = "3"
          write_envfile <<-EOF
            integer :foo
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(3)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("3")
        end

        it "loads an unset integer variable with a default value" do
          write_envfile <<-EOF
            integer :foo, default: 3
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(3)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("3")
        end

        it "loads a set integer variable with a default value" do
          ENV["FOO"] = "4"
          write_envfile <<-EOF
            integer :foo, default: 3
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(4)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("4")
        end

        it "raises an error if an unset integer variable is required" do
          write_envfile <<-EOF
            integer :foo
            EOF

          expect { Figaro::Config.load }.to raise_error(Figaro::Error)
        end

        it "loads an optional, unset integer variable" do
          write_envfile <<-EOF
            integer :foo, required: false
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(nil)
          expect(config.foo?).to eq(false)
          expect(ENV["FOO"]).to eq(nil)
        end

        it "loads an unset integer variable when dynamically optional" do
          write_envfile <<-EOF
            integer :foo, required: false
            integer :bar, required: -> { foo? }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to eq(nil)
          expect(config.bar?).to eq(false)
          expect(ENV["BAR"]).to eq(nil)
        end

        it "loads an integer variable from a custom ENV key" do
          ENV["FU"] = "3"
          write_envfile <<-EOF
            integer :foo, key: "FU"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(3)
          expect(config.foo?).to eq(true)
          expect(ENV["FU"]).to eq("3")
        end

        it "loads a integer variable with a dynamically set default value" do
          ENV["FOO"] = "3"
          write_envfile <<-EOF
            integer :foo
            integer :bar, default: -> { foo }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to eq(3)
          expect(config.bar?).to eq(true)
          expect(ENV["BAR"]).to eq("3")
        end

        it "loads a integer variable with a non-integer default value" do
          write_envfile <<-EOF
            integer :foo, default: "3"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(3)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("3")
        end

        it "loads a negative integer variable" do
          ENV["FOO"] = "-3"
          write_envfile <<-EOF
            integer :foo
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(-3)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("-3")
        end
      end
    end
  end
end
