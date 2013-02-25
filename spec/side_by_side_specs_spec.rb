require "rspec"
require "rake"
require "tmpdir"
require File.join(File.dirname(__FILE__), '../tools/Rake/side_by_side_specs.rb')

include FileUtils

describe "side-by-side specs" do
  context "when removing all spec-related information from a .NET project" do
    before(:all) do
      @dir = Dir.mktmpdir(nil, ENV['TEMP'])

      cp_r File.join(File.dirname(__FILE__), 'side_by_side_specs/.'), @dir

      SideBySideSpecs.new({
                                  :references => %w(Sample-Ref-1 Sample-Ref-2),
                                  :projects => FileList.new("#{@dir}/**/*.csproj"),
                                  :spec_globs => %w(*Specs.cs **/*Specs.cs),
                                  :specs => FileList.new("#{@dir}/**/*Specs.cs")
                          }).remove
    end

    after(:all) do
      rm_rf @dir
    end

    it "should delete all specs" do
      File.exists?("#{@dir}/FooSpecs.cs").should == false
    end

    it "should remove references from project files" do
      File.read("#{@dir}/sample.csproj").should_not include "Sample-Ref-1", "Sample-Ref-2"
    end

    it "should remove compiled spec sources from project files" do
      File.read("#{@dir}/sample.csproj").should_not include "Specs.cs", "SampleSpecs.cs"
    end
  end
end
