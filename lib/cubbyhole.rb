require "cubbyhole/version"

def Object.const_missing(name)
  eval "#{name} = Class.new(Cubbyhole::Base)"
end

module Cubbyhole
  class Base
    def foo
      "asf"
    end
  end
end
