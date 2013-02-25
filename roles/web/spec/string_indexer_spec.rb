require 'rspec'
require File.join(File.dirname(__FILE__), '../lib/string_indexer.rb')

describe "item attributes" do
  context "when requesting a missing attribute" do
    it "should yield nil" do
      hsh = { }
      hsh.extend Helpers::StringIndexer

      hsh.attr("missing").should be_nil
      hsh.attr("missing.foo.bar").should be_nil
    end

    it "should yield the default value" do
      hsh = Hash.new(42)
      hsh.extend Helpers::StringIndexer

      hsh.attr("missing").should == 42
      hsh.attr("missing.foo.bar").should == 42
    end

    it "should yield the default value as specified by the block" do
      hsh = Hash.new { |hash, key| "block #{hash} #{key}" }
      hsh.extend Helpers::StringIndexer

      hsh.attr("missing").should == "block {} missing"
    end
  end

  context "when requesting an attribute" do
    it "should yield the attribute value" do
      hsh = { :without_child => 23 }
      hsh.extend Helpers::StringIndexer

      hsh.attr("without_child").should == 23
      hsh[:without_child].should == 23
    end
  end

  context "when requesting a nested attribute" do
    it "should yield the attribute value" do
      hsh = { :with_child => { :value => 42 } }
      hsh.extend Helpers::StringIndexer

      hsh.attr("with_child.value").should == 42
      hsh[:with_child][:value].should == 42
    end
  end

  context "when requesting an attribute with children" do
    it "should yield the attribute value" do
      hsh = { :with_child => { :value => 42 } }
      hsh.extend Helpers::StringIndexer

      hsh.attr("with_child").should == { :value => 42 }
      hsh[:with_child].should == { :value => 42 }
    end
  end

  context "when requesting a missing nested attribute" do
    it "should yield nil" do
      hsh = { :with_child => { :value => 42 } }
      hsh.extend Helpers::StringIndexer

      hsh.attr("with_child.foo").should be_nil
    end

    it "should yield the default value" do
      hsh = { :with_child => { :value => 42 } }
      hsh.default = "default"
      hsh[:with_child].default = "default of child"
      hsh.extend Helpers::StringIndexer

      hsh.attr("with_child.foo").should == "default of child"
    end
  end

  context "when requesting a key that has both string and symbol keys" do
    it "should yield the attribute value" do
      hsh = { :key => "symbol value", "key" => "string value" }
      hsh.extend Helpers::StringIndexer

      hsh.attr("key").should == "string value"
      hsh[:key].should == "symbol value"
    end
  end

  context "when accessing arrays" do
    it "should fail" do
      hsh = { }
      hsh.extend Helpers::StringIndexer

      expect { hsh.attr("foo[0]") }.to raise_error Helpers::StringIndexer::ArrayAccessError
    end
  end

  context "when extending something else but Hash" do
    it "should fail" do
      expect {
        class Foo
          include Helpers::StringIndexer
        end
      }.to raise_error Helpers::StringIndexer::NotSupportedError, "StringIndexer was included in Foo, but only supports Hash"
    end
  end
end
