$:.push File.expand_path("../../lib", __FILE__)

require 'cubbyhole'

describe Cubbyhole::Collection do

  describe "with a bunch of things" do
    before do
      Thing.nuke
      Thing.create(:name => "thing1", :color => "brown", :shape => "triangle")
      Thing.create(:name => "thing2", :color => "green", :shape => "triangle")
      Thing.create(:name => "thing3", :color => "brown", :shape => "triangle")
      Thing.create(:name => "thing4", :color => "green", :shape => "square")
      Thing.create(:name => "thing5", :color => "blue", :shape => "triangle")
    end

    it "can find them all" do
      Thing.all.size.should eq 5
      Thing.all(:color => "green").size.should eq 2
    end

    it "can find the first" do
      Thing.first.name.should eq "thing1"
      Thing.first(:color => "green").name.should eq "thing2"
    end

    it "can find the last" do
      Thing.last.name.should eq "thing5"
      Thing.last(:color => "brown").name.should eq "thing3"
    end

    it "can chain finds" do
      browntriangles = Thing.all(:color => "brown").all(:shape => "triangle")
      browntriangles.size.should eq 2
      browntriangles.last.name.should eq "thing3"

      bluetriangle = Thing.all(:shape => "triangle").first(:color => "blue")
      bluetriangle.name.should eq "thing5"
    end

  end
end