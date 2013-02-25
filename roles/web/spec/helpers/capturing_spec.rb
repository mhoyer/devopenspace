require "rspec"
require "erb"
require "nanoc"
require File.join(File.dirname(__FILE__), '../../lib/helpers/capturing.rb')

include Helpers::Capturing

describe "capturing" do
  context "no captures" do
    before(:all) do
      @template = "head foot"
      @item = Nanoc::Item.new('foo', { }, '/blah/')

      @content = ::ERB.new(@template).result(binding)
      @capture = capture_for(@item, :sidebar)
      @sidebar = content_for(@item, :sidebar)
      @metadata = metadata_for(@item, :sidebar)
    end

    it "should yield content" do
      @content.should match "head foot"
    end

    it "should not have a capture" do
      @capture.should be_nil
    end

    it "should not have capture content" do
      @capture.should be_nil
    end

    it "should not have capture metadata" do
      @capture.should be_nil
    end
  end

  context "capturing without metadata" do
    before(:all) do
      @template = "head <% content_for :sidebar do %>\n" +
              "  sidebar\n" +
              "<% end %> foot"
      @item = Nanoc::Item.new('foo', { }, '/blah/')

      @content = ::ERB.new(@template).result(binding)
      @capture = capture_for(@item, :sidebar)
      @sidebar = content_for(@item, :sidebar)
      @metadata = metadata_for(@item, :sidebar)
    end

    it "should yield content without sidebar" do
      @content.should match /^head\s+foot$/
    end

    it "should capture the sidebar" do
      @capture.should be_a Hash
    end

    it "should capture sidebar content" do
      @sidebar.should match "sidebar"
    end

    it "should not have sidebar metadata" do
      @metadata.should be_empty
    end

    it "should not have other captures" do
      capture_for(@item, :other).should be_nil
    end
  end

  context "capturing with metadata" do
    before(:all) do
      @template = "head <% content_for :sidebar, :foo do %>\n" +
              "  sidebar\n" +
              "<% end %> foot"
      @item = Nanoc::Item.new('foo', { }, '/blah/')

      @content = ::ERB.new(@template).result(binding)
      @capture = capture_for(@item, :sidebar)
      @sidebar = content_for(@item, :sidebar)
      @metadata = metadata_for(@item, :sidebar)
    end

    it "should yield content without sidebar" do
      @content.should match /^head\s+foot$/
    end

    it "should capture the sidebar" do
      @capture.should be_a Hash
    end

    it "should capture sidebar content" do
      @sidebar.should match "sidebar"
    end

    it "should have sidebar metadata" do
      @metadata.should include :foo
    end

    it "should not have other captures" do
      capture_for(@item, :other).should be_nil
    end
  end
end
