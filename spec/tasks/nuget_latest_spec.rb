require 'tasks/nuget_latest'

describe NuGetLatest do
  context "when no package was found in the current path" do
    it "should fail" do
      expect { NuGetLatest.new('does-not-exist') }.to raise_error "No package 'does-not-exist' was found in #{Dir.pwd}"
    end
  end

  context "when no package was found in the specified path" do
    it "should fail" do
      dir = File.join(File.dirname(__FILE__), 'nuget_latest_spec')
      expect { NuGetLatest.new('does-not-exist', dir) }.to raise_error "No package 'does-not-exist' was found in #{dir}"
    end
  end

  context "when the specified path is not a directory" do
    it "should fail" do
      expect { NuGetLatest.new('does-not-exist', __FILE__) }.to raise_error "#{__FILE__} is not a directory"
    end
  end

  describe "packages found" do
    before(:all) do
      @dir = File.join File.dirname(__FILE__), 'nuget_latest_spec'
    end

    context "when one version exists" do
      it "should yield that version" do
        NuGetLatest.new('OneVersion', @dir).path.should == "#{@dir}/OneVersion.1.0.0"
      end
    end

    context "when two versions exists" do
      it "should yield the latest version" do
        NuGetLatest.new('TwoVersions', @dir).path.should == "#{@dir}/TwoVersions.1.0.1"
      end
    end

    context "when no version numbers are used" do
      it "should yield the only version" do
        NuGetLatest.new('NoVersionNumber', @dir).path.should == "#{@dir}/NoVersionNumber"
      end
    end

    context "when a newer beta package is installed" do
      it "should yield the latest version" do
        NuGetLatest.new('Beta', @dir).path.should == "#{@dir}/Beta.0.5.11-beta8"
      end
    end

    context "when weird but valid package IDs are found" do
      it "should yield the latest version for numbers" do
        NuGetLatest.new('Weird-123.456.789', @dir).path.should == "#{@dir}/Weird-123.456.789.1.0.1"
      end

      it "should yield the latest version when for multiple version separators" do
        NuGetLatest.new('Weird-nuget-core_is.cool', @dir).path.should == "#{@dir}/Weird-nuget-core_is.cool.1.0.1"
      end
    end
    
    context "when using conversion" do
      it "should succeed" do
        NuGetLatest('TwoVersions', @dir).should be_a NuGetLatest
      end
    end

    context "when appending strings" do
      it "should concatenate" do
        str = NuGetLatest.new('TwoVersions', @dir) + "/foo"
        str.should == "#{@dir}/TwoVersions.1.0.1/foo"
      end
    end
  end
end
