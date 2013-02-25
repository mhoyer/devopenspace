require 'rspec'
require 'haml'
require File.join(File.dirname(__FILE__), '../../lib/helpers/blocks.rb')

include Helpers::Blocks

class Sut
  include Helpers::Blocks

  attr_reader :haml_buffer

  def initialize
    @haml_buffer = Haml::Buffer.new(nil, { :encoding => 'external', :preserve => [] })
  end
end

describe "generic block" do
  context "without capture" do
    it "should yield nil" do
      block(nil).should be_nil
    end
  end

  context "with capture without renderer metadata" do
    it "should yield markup" do
      block({ :content => '# Kramdown' }).should include "<h1", "Kramdown"
    end
  end

  context "with capture with haml renderer metadata" do
    before(:all) do
      @subject = Sut.new
      @template = <<EOT
%h1
  Haml
EOT
    end

    it "should yield markup" do
      @subject.block({ :content => @template, :metadata => [:haml] }).should include "<h1>", "Haml"
    end
  end
end

describe "markdown block" do
  context "without contents" do
    it "should yield nil" do
      kramdown_block(nil).should be_nil
    end
  end

  context "with contents" do
    it "should yield markup" do
      kramdown_block("* blah").should include "<ul>", "<li>"
    end
  end

  context "not stripping outer paragraph" do
    it "should yield markup" do
      kramdown_block("blah").should include "<p>blah</p>"
    end
  end

  context "stripping outer paragraph" do
    it "should yield markup" do
      kramdown_block("blah", true).should == "blah"
    end
  end
end

describe "haml block" do
  context "without contents" do
    before(:all) do
      @subject = Sut.new
    end

    it "should yield nil" do
      @subject.haml_block(nil).should be_nil
    end
  end

  context "with contents" do
    before(:all) do
      @subject = Sut.new
      @template = <<EOT
%h1
  blah
EOT
    end

    it "should yield markup" do
      @subject.haml_block(@template).should include "<h1>"
    end
  end
end

