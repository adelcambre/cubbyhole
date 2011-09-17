$:.push File.expand_path("../../lib", __FILE__)

require 'cubbyhole'

describe Cubbyhole do
  it "makes constants" do
    NewConstant.new.foo.should == nil
  end

  it "allows you to set attrs on new" do
    model = NewModel.new(:foo => "bar", :baz => "bang")
    model.foo.should == "bar"
    model.baz.should == "bang"
  end

  it "allows you to save and fetch objects" do
    model = NewModel.new(:foo => "bar")
    model.save

    fetched = NewModel.get(model.id)
    fetched.foo.should == "bar"
  end

  it "should not persist unsaved objects" do
    model = NewModel.new(:foo => "bar")

    NewModel.get(model.id).should be_nil
  end

  it "allows you to create saved objects" do
    model = NewModel.create(:foo => "bar")

    fetched = NewModel.get(model.id)
    fetched.foo.should == "bar"
  end

  it "allows you to set and retrieve attributes" do
    model = NewModel.new
    model.foo.should == nil
    model.foo = "bar"
    model.foo.should == "bar"
  end

  it "allows you to update_attributes" do
    model = NewModel.new(:foo => "bar")
    model.save
    model.update_attributes(:foo => "baz", :bar => "zot")

    fetched = NewModel.get(model.id)
    fetched.foo.should == "baz"
    fetched.bar.should == "zot"
  end

  it "finds all objects" do
    3.times { MyModel.create }

    MyModel.all.size.should == 3
  end

  it "allows you to destroy objects" do
    object = MyModel.create
    id = object.id

    object.destroy
    MyModel.get(object.id).should be_nil
  end
end
