# Cubbyhole - The zero config, non-production, datastore

Sinatra is dead simple, but it's more interesting to play with if you can store some data. The problem is that setting up ActiveRecord or DataMapper significantly complicates things.

Cubbyhole is designed to be absolutely zero config.

```ruby
require 'cubbyhole'

post = Post.create(:title => "Foo", :text => "Bar")

Post.get(post.id).title # => Foo
```
