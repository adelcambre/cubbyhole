require 'sdbm'

module Cubbyhole
  class SDBM
    extend Forwardable
    def_delegators :@sdbm, :clear

    def initialize(name)
      @name = name
      @sdbm = ::SDBM.new("cubbyhole.sdbm")
    end

    def [](key)
      if str = @sdbm[munge_key(key)]
        Marshal.load(str)
      end
    end

    def []=(key, val)
      @sdbm[munge_key(key)] = Marshal.dump(val)
    end

    def keys
      @sdbm.keys.grep(/^#{@name}:/).map do |key|
        key.sub(/^#{@name}:/, "")
      end
    end

    def delete(key)
      @sdbm.delete(munge_key(key))
    end

    def munge_key(key)
      "#{@name}:#{key}"
    end

  end
end
