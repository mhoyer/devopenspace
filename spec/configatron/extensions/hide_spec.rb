require 'erb'
require 'configatron/extensions/hide'

describe "configatron extensions" do
  describe "when hiding keys" do
    before(:all) do
      @config = Configatron::Store.new({})
      @config.configure_from_hash(
              {
                      :nested => {
                              :password => "secret",
                              :another => { :password => "which is also secret" },
                      },
                      :hash => {
                              :password => {
                                      :is => "structured hash" }
                      },
                      :array => {
                              :password => ["structured array"]
                      },
                      :nil => {
                              :password => nil
                      }
              })

      @config.hide! :password
    end

    it "should hide the key's value when inspecting the configuration" do
      inspected = @config.inspect

      inspected.should_not match /secret/
    end

    it "should retain hashes matching the key" do
      inspected = @config.inspect

      inspected.should match /structured hash/
    end

    it "should retain arrays matching the key" do
      inspected = @config.inspect

      inspected.should match /structured array/
    end

    it "should use the underlying value in templating scenarios" do
      template = ERB.new "The value of key is: <%= @config.nested.password %>"

      template.result(binding).should match /secret/
    end

    it "should use the underlying nil value in templating scenarios" do
      template = ERB.new "The value of key is: <%= @config.nil.password %>"

      template.result(binding).should == "The value of key is: "
    end
  end
end
