require 'rspec'
require File.join(File.dirname(__FILE__), '../lib/item_tags.rb')

include Helpers::Items::Tags

describe "item tags" do
  context "when a known tag is used" do
    it "should use the text for the tag" do
      text_for('mvp').should == 'MVP'
    end

    it "should use the title for the tag" do
      title_for('mvp').should == 'Der Trainer wurde mit dem „Microsoft Most Valuable Professional“-Award ausgezeichnet.'
    end
  end

  context "when a known tag is used" do
    it "should use the text for the tag" do
      text_for('gruppe').should == 'Gruppe'
    end

    it "should use the title for the tag" do
      title_for('gruppe').should == 'Das Training optimiert die Zusammenarbeit und die Kommunikation insbesondere in der Gruppe.'
    end
  end

  context "when an unknown tag is used" do
    it "should use the tag as the text" do
      text_for('foo').should == 'foo'
    end

    it "should use the tag as the title" do
      title_for('foo').should == 'foo'
    end
  end

  context "when the regex-based tag for the training length is used" do
    it "should use the tag as the text" do
      text_for('3 Tage').should == '3 Tage'
    end

    it "should use the regex-based match title" do
      title_for('3 Tage').should == 'Die empfohlene Dauer des Trainings ist 3 Tage.'
    end
  end

  context "when the regex-based tag for the number of attendees is used" do
    it "should use the tag as the text" do
      text_for('für 6 - 8').should == 'für 6 - 8'
    end

    it "should use the regex-based match title" do
      title_for('für 6 - 8').should == 'Die empfohlene Anzahl Teilnehmer einer Gruppe ist 6 - 8.'
    end
  end
end
