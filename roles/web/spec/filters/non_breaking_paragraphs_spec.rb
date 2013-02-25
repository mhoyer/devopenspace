require "rspec"
require "nanoc"
require File.join(File.dirname(__FILE__), '../../lib/filters/replace.rb')

describe "non-breaking paragraphs" do
  before(:all) do
    @filter = Replace.new
    @params = {
            :pattern => /(\s)(§{1,2})\s+(\d)/,
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
      @template = "§ 1"

      @result = @filter.run(@template, @params)
    end

    it "should not alter content" do
      @result.should == @template
    end
  end

  context "marker with preceding whitespace" do
    before(:all) do
      @template = "foo § 1 bar"
      @result = @filter.run(@template, @params)
    end

    it "should place a non-breaking space between marker and succeeding content" do
      @result.should == "foo §&nbsp;1 bar"
    end
  end

  context "double marker with preceding whitespace" do
    before(:all) do
      @template = "foo §§ 1, 2 bar"
      @result = @filter.run(@template, @params)
    end

    it "should place a non-breaking space between marker and succeeding content" do
      @result.should == "foo §§&nbsp;1, 2 bar"
    end
    end

  context "triple marker with preceding whitespace" do
    before(:all) do
      @template = "foo §§§ 1, 2 bar"
      @result = @filter.run(@template, @params)
    end

    it "should not alter content" do
      @result.should == @template
    end
  end
end
