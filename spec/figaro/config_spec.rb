require "spec_helper"

module Figaro
  describe Config do
    describe ".load" do
      it "handles a simple string variable" do
        write_envfile <<-EOF
          string :foo
          EOF

        config = Figaro::Config.load

        expect(config).to respond_to(:foo)
        expect(config).to respond_to(:foo=)
        expect(config).to respond_to(:foo?)
        expect(config.foo).to eq(nil)
        expect(config.foo?).to eq(false)
        expect(ENV["FOO"]).to eq(nil)
      end
    end
  end
end
