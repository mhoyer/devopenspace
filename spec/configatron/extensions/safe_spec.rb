require 'erb'
require 'configatron/extensions/safe'

describe "configatron extensions" do
  describe "when a safe configuration is used in a templating scenario" do
    before(:all) do
      @config = Configatron::Store.new({})
      @config.configure_from_hash({ :nested => { :key => "value" } })

      @config.safe!
    end

    context "when the dereferenced key does not exists" do
      before(:all) do
        @template = ERB.new "The value of key is: <%= @config.nested.does.not.exist %>"
      end

      it "should fail when accessing an unassigned key" do
        expect { @template.result(binding) }.to raise_error
      end
    end

    context "when the dereferenced key does exists" do
      before(:all) do
        template = ERB.new "The value of key is: <%= @config.nested.key %>"
        @result = template.result(binding)
      end

      it "should create the template result" do
        @result.should include("The value of key is: value")
      end
    end
  end
end
