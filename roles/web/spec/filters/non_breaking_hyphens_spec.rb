require "rspec"
require "nanoc"
require File.join(File.dirname(__FILE__), '../../lib/filters/replace.rb')

describe "non-breaking hyphens" do
  before(:all) do
    @filter = Replace.new
    @params = {
            :pattern => /(\s)(\-\w+)/,
            :replacement => '\1<span class="nowrap">\2</span>'
    }
  end

  context "no hyphens" do
    before(:all) do
      @template = "this text does not contain hyphens"
      @result = @filter.run(@template, @params)
    end

    it "should not alter content" do
      @result.should == @template
    end
  end

  context "hyphens without succeeding text" do
    before(:all) do
      @template = "this - text - contains hyphens without immediately succeeding text"

      @result = @filter.run(@template, @params)
    end

    it "should not alter content" do
      @result.should == @template
    end
  end

  context "hyphens without preceding whitespace" do
    before(:all) do
      @template = "this text-contains hyphens without preceding whitespace"
      @result = @filter.run(@template, @params)
    end

    it "should not alter content" do
      @result.should == @template
    end
  end

  context "hyphens with succeeding text" do
    before(:all) do
      @template = "this -text -contains 2 occurrences of hyphens with immediately succeeding text"
      @result = @filter.run(@template, @params)
    end

    it "should wrap hyphens in <span>" do
      @result.should == 'this <span class="nowrap">-text</span> <span class="nowrap">-contains</span> 2 occurrences of hyphens with immediately succeeding text'
    end
  end

  context "hyphens with succeeding numbers" do
    before(:all) do
      @template = "this text contains -2 occurrences of hyphens with immediately succeeding text"
      @result = @filter.run(@template, @params)
    end

    it "should wrap hyphens in <span>" do
      @result.should == 'this text contains <span class="nowrap">-2</span> occurrences of hyphens with immediately succeeding text'
    end
  end
end
