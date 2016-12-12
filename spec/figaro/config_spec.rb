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

        it "loads a string variable from a custom ENV key" do
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

      context "decimal" do
        it "loads a set decimal variable" do
          ENV["FOO"] = "1.23"
          write_envfile <<-EOF
            decimal :foo
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to be_a(BigDecimal)
          expect(config.foo).to eq(1.23)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("1.23")
        end

        it "loads an unset decimal variable with a string default value" do
          write_envfile <<-EOF
            decimal :foo, default: "1.23"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to be_a(BigDecimal)
          expect(config.foo).to eq(1.23)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("1.23")
        end

        # TODO: Decide whether to allow loading from a float. Floats are buggy.
        it "loads an unset decimal variable with a float default value" do
          write_envfile <<-EOF
            decimal :foo, default: 1.23
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to be_a(BigDecimal)
          expect(config.foo).to eq(1.23)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("1.23")
        end

        it "loads a set decimal variable with a default value" do
          ENV["FOO"] = "2.34"
          write_envfile <<-EOF
            decimal :foo, default: "1.23"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to be_a(BigDecimal)
          expect(config.foo).to eq(2.34)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("2.34")
        end

        it "raises an error if an unset decimal variable is required" do
          write_envfile <<-EOF
            decimal :foo
            EOF

          expect { Figaro::Config.load }.to raise_error(Figaro::Error)
        end

        it "loads an optional, unset decimal variable" do
          write_envfile <<-EOF
            decimal :foo, required: false
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(nil)
          expect(config.foo?).to eq(false)
          expect(ENV["FOO"]).to eq(nil)
        end

        it "loads an unset decimal variable when dynamically optional" do
          write_envfile <<-EOF
            decimal :foo, required: false
            decimal :bar, required: -> { foo? }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to eq(nil)
          expect(config.bar?).to eq(false)
          expect(ENV["BAR"]).to eq(nil)
        end

        it "loads a decimal variable from a custom ENV key" do
          ENV["FU"] = "1.23"
          write_envfile <<-EOF
            decimal :foo, key: "FU"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to be_a(BigDecimal)
          expect(config.foo).to eq(1.23)
          expect(config.foo?).to eq(true)
          expect(ENV["FU"]).to eq("1.23")
        end

        it "loads a decimal variable with a dynamically set default value" do
          ENV["FOO"] = "1.23"
          write_envfile <<-EOF
            decimal :foo
            decimal :bar, default: -> { foo }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to be_a(BigDecimal)
          expect(config.bar).to eq(1.23)
          expect(config.bar?).to eq(true)
          expect(ENV["BAR"]).to eq("1.23")
        end

        it "loads a negative decimal variable" do
          ENV["FOO"] = "-1.23"
          write_envfile <<-EOF
            decimal :foo
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to be_a(BigDecimal)
          expect(config.foo).to eq(-1.23)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("-1.23")
        end
      end

      context "boolean" do
        it "loads a boolean variable set to true" do
          ENV["FOO"] = "true"
          write_envfile <<-EOF
            boolean :foo
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(true)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("true")
        end

        it "loads an unset boolean variable with a default value" do
          write_envfile <<-EOF
            boolean :foo, default: true
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(true)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("true")
        end

        it "loads a set boolean variable with a default value" do
          ENV["FOO"] = "false"
          write_envfile <<-EOF
            boolean :foo, default: true
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(false)
          expect(config.foo?).to eq(false)
          expect(ENV["FOO"]).to eq("false")
        end

        it "raises an error if an unset boolean variable is required" do
          write_envfile <<-EOF
            boolean :foo
            EOF

          expect { Figaro::Config.load }.to raise_error(Figaro::Error)
        end

        it "loads an optional, unset boolean variable" do
          write_envfile <<-EOF
            boolean :foo, required: false
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(nil)
          expect(config.foo?).to eq(false)
          expect(ENV["FOO"]).to eq(nil)
        end

        it "loads an unset boolean variable when dynamically optional" do
          write_envfile <<-EOF
            boolean :foo, required: false
            boolean :bar, required: -> { foo? }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to eq(nil)
          expect(config.bar?).to eq(false)
          expect(ENV["BAR"]).to eq(nil)
        end

        it "loads a boolean variable from a custom ENV key" do
          ENV["FU"] = "true"
          write_envfile <<-EOF
            boolean :foo, key: "FU"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(true)
          expect(config.foo?).to eq(true)
          expect(ENV["FU"]).to eq("true")
        end

        it "loads a boolean variable with a dynamically set default value" do
          ENV["FOO"] = "true"
          write_envfile <<-EOF
            boolean :foo
            boolean :bar, default: -> { foo }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to eq(true)
          expect(config.bar?).to eq(true)
          expect(ENV["BAR"]).to eq("true")
        end

        it "loads a boolean variable with a non-boolean default value" do
          write_envfile <<-EOF
            boolean :foo, default: "yes"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(true)
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("yes")
        end
      end

      context "array" do
        it "loads a set array variable" do
          ENV["FOO"] = "bar,baz"
          write_envfile <<-EOF
            array :foo
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(["bar", "baz"])
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("bar,baz")
        end

        it "loads a set array variable with a custom separator" do
          ENV["FOO"] = "bar|baz"
          write_envfile <<-EOF
            array :foo, separator: "|"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(["bar", "baz"])
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("bar|baz")
        end

        it "loads an unset array variable with a default value" do
          write_envfile <<-EOF
            array :foo, default: ["bar", "baz"]
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(["bar", "baz"])
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("bar,baz")
        end

        it "loads an unset array variable with a default value and a custom separator" do
          write_envfile <<-EOF
            array :foo, default: ["bar", "baz"], separator: "|"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(["bar", "baz"])
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("bar|baz")
        end

        it "loads a set array variable with a default value" do
          ENV["FOO"] = "bar,baz"
          write_envfile <<-EOF
            array :foo, default: ["bar", "baz", "qux"]
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(["bar", "baz"])
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("bar,baz")
        end

        it "raises an error if an unset array variable is required" do
          write_envfile <<-EOF
            array :foo
            EOF

          expect { Figaro::Config.load }.to raise_error(Figaro::Error)
        end

        it "loads an optional, unset array variable" do
          write_envfile <<-EOF
            array :foo, required: false
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(nil)
          expect(config.foo?).to eq(false)
          expect(ENV["FOO"]).to eq(nil)
        end

        it "loads an unset array variable when dynamically optional" do
          write_envfile <<-EOF
            array :foo, required: false
            array :bar, required: -> { foo? }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to eq(nil)
          expect(config.bar?).to eq(false)
          expect(ENV["BAR"]).to eq(nil)
        end

        it "loads an array variable from a custom ENV key" do
          ENV["FU"] = "bar,baz"
          write_envfile <<-EOF
            array :foo, key: "FU"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(["bar", "baz"])
          expect(config.foo?).to eq(true)
          expect(ENV["FU"]).to eq("bar,baz")
        end

        it "loads an array variable with a dynamically set default value" do
          ENV["FOO"] = "bar,baz"
          write_envfile <<-EOF
            array :foo
            array :bar, default: -> { foo }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:bar)
          expect(config).to respond_to(:bar=)
          expect(config).to respond_to(:bar?)
          expect(config.bar).to eq(["bar", "baz"])
          expect(config.bar?).to eq(true)
          expect(ENV["BAR"]).to eq("bar,baz")
        end

        it "loads an array variable with a non-array default value" do
          write_envfile <<-EOF
            array :foo, default: "bar,baz"
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq(["bar", "baz"])
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("bar,baz")
        end

        it "loads an array variable with non-string values" do
          ENV["FOO"] = "1,2,3"
          write_envfile <<-EOF
            array :foo, type: :integer
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq([1, 2, 3])
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("1,2,3")
        end

        it "loads a nested array variable with non-string values" do
          ENV["FOO"] = "1,2,3|4,5,6|7,8,9"
          write_envfile <<-EOF
            array :foo, separator: "|", type: :array, type_options: { type: :integer }
            EOF

          config = Figaro::Config.load

          expect(config).to respond_to(:foo)
          expect(config).to respond_to(:foo=)
          expect(config).to respond_to(:foo?)
          expect(config.foo).to eq([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          expect(config.foo?).to eq(true)
          expect(ENV["FOO"]).to eq("1,2,3|4,5,6|7,8,9")
        end
      end
    end
  end
end
