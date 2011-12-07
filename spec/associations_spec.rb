$:.push File.expand_path("../../lib", __FILE__)

require 'cubbyhole'

describe Cubbyhole do
  context "belongs_to" do
    it "saves the children when the parent is saved" do
      comment = Comment.create(:body => "My Comment")
      post = Post.new(:title => "Foo", :body => "Bar")

      post.should_not be_persisted

      comment.post = post
      comment.save
      post.should be_persisted
    end

    it "works bidirectionally" do
      comment = FooComment.new(:body => "My Comment")
      post = Post.new(:title => "Foo", :body => "Bar")

      comment.post = post
      post.foo_comments.should == [comment]
    end
  end

  context "has_many" do
    it "saves the children when the parent is saved" do
      comment = Comment.new(:body => "My Comment")
      post = Post.create(:title => "Foo", :body => "Bar")

      comment.should_not be_persisted

      post.comments = [comment]
      post.save
      comment.should be_persisted
    end

  end
end
