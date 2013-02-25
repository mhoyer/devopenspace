require "erb"
require "rspec"
require "configatron"
require File.join(File.dirname(__FILE__), '../../tools/Rake/configatron/safe.rb')

describe "when safe configatron is used in a templating scenario" do
  before(:all) do
    @config = Configatron::Store.new({ })
    @config.configure_from_hash({ :nested => { :key => "value" } })

    @config.safe!
  end

  context "when the dereferenced key does not exists" do
    before(:all) do
      @template = ERB.new "The value of key is: <%= @config.nested.does.not.exist %>"
    end

    it "should fail when accessing an unassigned key" do
      lambda { @template.result(binding) }.should raise_error
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
