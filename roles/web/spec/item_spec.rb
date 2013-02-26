require 'rspec'
require 'nanoc'
require File.join(File.dirname(__FILE__), '../lib/item.rb')
require File.join(File.dirname(__FILE__), '../lib/item_array.rb')

describe "navigation links" do
  context "when rendering an item containing a link to its parent" do
    before(:all) do
      @parent = Nanoc::Item.new("parent", { }, '/')
      @item = Nanoc::Item.new("item", { }, '/item/')
    end

    it "should indicate that the link leads to the item" do
      @parent.leads_to?(@item).should be_true
    end
  end

  context "when rendering an item containing a link to a child" do
    before(:all) do
      @item = Nanoc::Item.new("item", { }, '/item/')
      @child = Nanoc::Item.new("child", { }, '/item/child/')
    end

    it "should indicate that the link does not lead to the item" do
      @child.leads_to?(@item).should be_false
    end
  end

  context "when rendering an item containing a link to an unrelated page" do
    before(:all) do
      @item = Nanoc::Item.new("item", { }, '/item/')
      @unrelated = Nanoc::Item.new("unrelated", { }, '/unrelated/')
    end

    it "should indicate that the link does not lead to the item" do
      @unrelated.leads_to?(@item).should be_false
    end
  end
end

describe "page URLs" do
  describe "insecure pages" do
    before(:all) do
      @item = Nanoc::Item.new("item", { }, '/item/')
      rep = Nanoc::ItemRep.new(@item, :default)
      rep.paths[:last] = "path/to/the/item"
      @item.reps << rep

      require 'configatron'
      configatron.reset!
      configatron.configure_from_hash({
                                              :roles => {
                                                      :web => {
                                                              :deployment => {
                                                                      :bindings => [
                                                                              { :host => 'host', :protocol => 'http' },
                                                                              { :host => 'host-ssl', :protocol => 'https' }
                                                                      ]
                                                              }
                                                      }
                                              }
                                      })
    end

    after(:all) do
      configatron.reset!
      undef configatron
    end

    context "when creating a link to an item" do
      it "should create a relative link" do
        @item.url.should == "/path/to/the/item"
      end
    end

    context "when creating an absolute link to an item" do
      it "should create an absolute link" do
        @item.absolute_url.should == "http://host/path/to/the/item"
      end
    end

    context "when creating an absolute link to an item in the development environment" do
      it "should create a relative link" do
        configatron.env = "development"
        @item.absolute_url.should == "/path/to/the/item"
        configatron.env = nil
      end
    end

    context "when creating an absolute link to a forwarded item" do
      before(:all) do
        module SiteMethods
          def items
            destination = Nanoc::Item.new("destination", { }, '/destination/')
            rep = Nanoc::ItemRep.new(destination, :default)
            rep.paths[:last] = "path/to/the/destination"
            destination.reps << rep

            [] << destination
          end
        end

        @item.site = Object.new.extend(SiteMethods)
        @item.attributes[:forward] = "/destination/"
      end

      it "should create an absolute link to the destination" do
        @item.absolute_url.should == "http://host/path/to/the/destination"
      end
    end
  end

  describe "secure pages" do
    describe "with configured certificate" do
      before(:all) do
        @item = Nanoc::Item.new("item", { }, '/item/')
        rep = Nanoc::ItemRep.new(@item, :default)
        rep.paths[:last] = "path/to/the/item"
        @item.reps << rep

        require 'configatron'
        configatron.reset!
        configatron.configure_from_hash({
                                                :roles => {
                                                        :web => {
                                                                :certificate => :configured,
                                                                :deployment => {
                                                                        :bindings => [
                                                                                { :host => 'host', :protocol => 'http' },
                                                                                { :host => 'host-ssl', :protocol => 'https' }
                                                                        ]
                                                                }
                                                        }
                                                }
                                        })
      end

      after(:all) do
        configatron.reset!
        undef configatron
      end

      context "when creating a link to an item" do
        before(:all) do
          @item.attributes[:secure] = true
        end

        it "should create an absolute https:// link to the first configured SSL binding" do
          @item.url.should == "https://host-ssl/path/to/the/item"
        end

        it "should create the same URL for relative and absolute links" do
          @item.absolute_url.should == @item.url
        end

        it "should create a relative link in the development environment" do
          configatron.env = "development"
          @item.absolute_url.should == "/path/to/the/item"
          configatron.env = nil
        end
      end
    end

    describe "without configured certificate" do
      before(:all) do
        @item = Nanoc::Item.new("item", { }, '/item/')
        rep = Nanoc::ItemRep.new(@item, :default)
        rep.paths[:last] = "path/to/the/item"
        @item.reps << rep

        require 'configatron'
        configatron.reset!
        configatron.configure_from_hash({
                                                :roles => {
                                                        :web => {
                                                                :deployment => {
                                                                        :bindings => [
                                                                                { :host => 'host', :protocol => 'http' },
                                                                                { :host => 'host-ssl', :protocol => 'https' }
                                                                        ]
                                                                }
                                                        }
                                                }
                                        })
      end

      after(:all) do
        configatron.reset!
        undef configatron
      end

      context "when creating a link to an item" do
        before(:all) do
          @item.attributes[:secure] = true
        end

        it "should create a relative link" do
          @item.url.should == "/path/to/the/item"
        end

        it "should create a relative link in the development environment" do
          configatron.env = "development"
          @item.absolute_url.should == "/path/to/the/item"
          configatron.env = nil
        end
      end
    end
  end
end
