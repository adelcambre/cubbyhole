require 'sdbm'

module Cubbyhole
  class SDBM
    extend Forwardable
    def_delegators :@sdbm, :keys, :delete, :clear

    def initialize(name)
      @sdbm = ::SDBM.new("cubbyhole.#{name}.sdbm")
    end

    def [](key)
      if str = @sdbm[key]
        Marshal.load(str)
      end
    end

    def []=(key, val)
      @sdbm[key] = Marshal.dump(val)
    end

  end
end
