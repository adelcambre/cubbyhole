require 'cubbyhole/version'
require 'sdbm'

def Object.const_missing(name)
  const_set(name, Class.new(Cubbyhole::Base))
end

module Cubbyhole
  class Base
    METHOD_BLACKLIST = [:marshal_load, :marshal_dump, :_dump, :_load]

    def self.create(params={})
      new(params).save
    end

    def self.get(id)
      if str = sdbm[id.to_s]
        Marshal.load(str)
      end
    end

    def self.next_id
      @next_id ||= 0
      id = @next_id
      @next_id += 1
      id
    end

    def self.all
      sdbm.values.map{|x| Marshal.load(x) }
    end

    def self.sdbm
      @sdbm ||= SDBM.new("cubbyhole.#{self.to_s}.sdbm")
    end

    def initialize(params={})
      @id = self.class.next_id
      @params = params
      @persisted = false
      stringify_keys!
    end

    attr_reader :id

    def persisted?
      @persisted
    end

    def save
      @persisted = true
      normalize_params!
      self.class.sdbm[id.to_s] = Marshal.dump(self)
      self
    end

    def destroy
      self.class.sdbm.delete(@id.to_s)
    end

    def method_missing(meth, *args, &blk)
      return super if METHOD_BLACKLIST.include?(meth.to_sym)

      key = meth.to_s

      if key =~ /=$/
        raise ArgumentError unless args.size == 1
        @params[key.gsub(/=$/, "")] = args.first
      else
        return super if args.size != 0
        @params[key]
      end
    end

    def respond_to?(meth)
      return super if METHOD_BLACKLIST.include?(meth.to_sym)
      true
    end

    def update_attributes(params)
      @params.merge!(params)
      stringify_keys!
      save
    end

    def normalize_params!
      @params.default = nil

      @params.keys.each do |key|
        @params[key.to_s] = @params.delete(key)
      end
      @params
    end
  end
end
