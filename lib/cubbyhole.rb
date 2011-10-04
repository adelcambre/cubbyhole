require 'cubbyhole/version'
require 'cubbyhole/base'

def Object.const_missing(name)
  const_set(name, Class.new(Cubbyhole::Base))
end
