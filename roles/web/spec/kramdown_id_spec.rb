require 'rspec'
require File.join(File.dirname(__FILE__), '../lib/kramdown_id.rb')

describe "ID generation" do
  context "when generating a HTML ID with umlauts" do
    it "should replace umlauts with their non-umlaut equivalent" do
      'ä ö ü ß'.kramdown_id.should == "ae-oe-ue-ss"
    end
  end
end

