require "rspec"
require "nanoc"
require File.join(File.dirname(__FILE__), '../../lib/filters/replace.rb')

describe "non-breaking numbers" do
  before(:all) do
    @filter = Replace.new
    @params = {
            :pattern => /(\s)(Nr\.)\s+(.)/,
            :replacement => '\1\2&nbsp;\3'
    }
  end

  context "no marker" do
    before(:all) do
      @template = "this text does not contain the marker"
      @result = @filter.run(@template, @params)
    end

    it "should not alter content" do
      @result.should == @template
    end
  end

  context "marker without preceding whitespace" do
    before(:all) do
      @template = "Nr. 1"

      @result = @filter.run(@template, @params)
    end

    it "should not alter content" do
      @result.should == @template
    end
  end

  context "marker with preceding whitespace" do
    before(:all) do
      @template = "foo Nr. 1 bar"
      @result = @filter.run(@template, @params)
    end

    it "should place a non-breaking space between marker and succeeding content" do
      @result.should == "foo Nr.&nbsp;1 bar"
    end
  end
end
