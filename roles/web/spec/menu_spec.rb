require 'rspec'
require 'rspec/mocks'
require 'nanoc'
require 'haml'
require File.join(File.dirname(__FILE__), '../lib/menu.rb')

include RSpec::Mocks::ExampleMethods

describe "menu" do
  include Helpers::Navigation::Menu
  include Haml::Helpers

  before(:all) do
    init_haml_helpers
  end

  context "when rendering the menu" do
    it "should hide level-2 items without a menu order" do
      parent = Nanoc::Item.new("parent", { :title => "/parent/" }, '/parent/')
      child = Nanoc::Item.new("parent child", { :title => "/parent/child/" }, '/parent/child/')
      parent.children = [child]

      html = capture_haml {
        menu_tag([parent])
      }

      html.should include "/parent/"
      html.should_not include "/parent/child/"
    end

    it "should render recursively" do
      parent = Nanoc::Item.new("parent", { :title => "/parent/" }, '/parent/')
      child = Nanoc::Item.new("parent child", { :title => "/parent/child/", :menu_order => 0 }, '/parent/child/')
      parent.children = [child]

      html = capture_haml {
        menu_tag([parent])
      }

      html.should include "/parent/"
      html.should include "/parent/child/"
    end

    it "should render recursively until the specified depth" do
      parent = Nanoc::Item.new("parent", { :title => "/parent/" }, '/parent/')
      child = Nanoc::Item.new("parent child", { :title => "/parent/child/", :menu_order => 0 }, '/parent/child/')
      parent.children = [child]

      html = capture_haml {
        menu_tag([parent], { :depth => 1 })
      }

      html.should include "/parent/"
      html.should_not include "/parent/child/"
    end

    it "should hide hidden items" do
      parent = Nanoc::Item.new("parent", { :title => "/parent/", :hide_in_menu => true }, '/parent/')

      html = capture_haml {
        menu_tag([parent])
      }

      html.should_not include "/parent/"
    end
  end
end
