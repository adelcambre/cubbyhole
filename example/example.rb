require 'sinatra/base'
require 'cubbyhole'
require 'haml'

class Example < Sinatra::Base
  get "/" do
    @posts = Post.all
    haml :index
  end

  get "/posts/new" do
    haml :new
  end

  post "/posts" do
    Post.create(params[:post])
    redirect "/"
  end
end
