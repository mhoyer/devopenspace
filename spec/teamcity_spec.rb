require 'rspec'
require File.join(File.dirname(__FILE__), '../tools/Rake/teamcity.rb')

describe "TeamCity service messages" do
  describe "publishing" do
    before(:all) do
      @original_project = ENV['TEAMCITY_PROJECT_NAME']
      ENV.delete 'TEAMCITY_PROJECT_NAME'
    end

    after(:all) do
      ENV['TEAMCITY_PROJECT_NAME'] = @original_project
    end

    context "when running outside TeamCity" do
      it "should not publish messages" do
        TeamCity.running?.should == false
      end
    end
    context "when running inside TeamCity" do
      before(:all) do
        @original_project = ENV['TEAMCITY_PROJECT_NAME']
        ENV['TEAMCITY_PROJECT_NAME'] = "foo"
      end

      after(:all) do
        ENV['TEAMCITY_PROJECT_NAME'] = @original_project
      end

      it "should not publish messages" do
        TeamCity.running?.should == true
      end
    end
  end
end

describe "service messages" do
  before(:all) do
    @original_project = ENV['TEAMCITY_PROJECT_NAME']
    ENV['TEAMCITY_PROJECT_NAME'] = "foo"
  end

  after(:all) do
    ENV['TEAMCITY_PROJECT_NAME'] = @original_project
  end

  describe "escaping" do
    context "when publishing messages with special characters" do
      it "should escape apostrophes" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '|'']")
        TeamCity.progress_start "'"
      end

      it "should escape line feeds" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '|n']")
        TeamCity.progress_start "\n"
      end

      it "should escape carriage returns" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '|r']")
        TeamCity.progress_start "\r"
      end

      it "should escape next lines" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '|x']")
        TeamCity.progress_start "\u0085"
      end

      it "should escape line separators" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '|l']")
        TeamCity.progress_start "\u2028"
      end

      it "should escape paragraph separators" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '|p']")
        TeamCity.progress_start "\u2029"
      end

      it "should escape vertical bars" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '||']")
        TeamCity.progress_start '|'
      end

      it "should escape opening brackets" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '|[']")
        TeamCity.progress_start '['
      end

      it "should escape closing brackets" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '|]']")
        TeamCity.progress_start ']'
      end

      it "should escape all special characters" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart '|[|r|||n|]']")
        TeamCity.progress_start "[\r|\n]"
      end
    end
  end

  describe "build progress" do
    context "when reporting build progress start" do
      it "should print the service message" do
        $stdout.should_receive(:puts).with("##teamcity[progressStart 'some task']")
        TeamCity.progress_start "some task"
      end
    end

    context "when reporting build progress end" do
      it "should print the service message" do
        $stdout.should_receive(:puts).with("##teamcity[progressFinish 'some task']")
        TeamCity.progress_finish "some task"
      end
    end
  end
end
