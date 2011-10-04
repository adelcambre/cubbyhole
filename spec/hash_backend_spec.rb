$:.push File.expand_path("../../lib", __FILE__)

require 'cubbyhole/base'

class BaseModel < Cubbyhole::Base
  def self.backend
    @backend ||= Hash.new
  end
end

class MyModelModel < BaseModel; end
class MyOtherModel < BaseModel; end

describe "Cubbyhole::Base subclass with self.backend of Hash.new" do

  it "allows you to set attrs on new" do
    model = MyModelModel.new(:foo => "bar", :baz => "bang")
    model.foo.should == "bar"
    model.baz.should == "bang"
  end

  it "allows you to save and fetch objects" do
    model = MyModelModel.new(:foo => "bar")
    model.save

    fetched = MyModelModel.get(model.id)
    fetched.foo.should == "bar"
  end

  it "should not persist unsaved objects" do
    model = MyModelModel.new(:foo => "bar")

    MyModelModel.get(model.id).should be_nil
  end

  it "allows you to create saved objects" do
    model = MyModelModel.create(:foo => "bar")

    fetched = MyModelModel.get(model.id)
    fetched.foo.should == "bar"
  end

  it "allows you to set and retrieve attributes" do
    model = MyModelModel.new
    model.foo.should == nil
    model.foo = "bar"
    model.foo.should == "bar"
  end

  it "allows you to update_attributes" do
    model = MyModelModel.new(:foo => "bar")
    model.save
    model.update_attributes(:foo => "baz", :bar => "zot")

    fetched = MyModelModel.get(model.id)
    fetched.foo.should == "baz"
    fetched.bar.should == "zot"
  end

  it "finds all objects" do
    3.times { MyOtherModel.create }

    MyOtherModel.all.size.should == 3
  end

  it "allows you to destroy objects" do
    object = MyOtherModel.create
    id = object.id

    object.destroy
    MyOtherModel.get(object.id).should be_nil
  end
end
