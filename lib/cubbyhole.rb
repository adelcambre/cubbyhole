require "cubbyhole/version"

def Object.const_missing(name)
  const_set(name, Class.new(Cubbyhole::Base))
end

module Cubbyhole
  class Base
    def self.create(params={})
      new(params).save
    end

    def self.get(id)
      objs[id]
    end

    def self.next_id
      @next_id ||= 0
      id = @next_id
      @next_id += 1
      id
    end

    def self.all
      objs.values
    end

    def self.objs
      @objs ||= {}
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
      stringify_keys!
      self.class.objs[@id] = self
    end

    def destroy
      self.class.objs.delete(@id)
    end

    def method_missing(meth, *args, &blk)
      key = meth.to_s

      if key =~ /=$/
        raise ArgumentError unless args.size == 1
        @params[key.gsub(/=$/, "")] = args.first
      else
        raise ArgumentError unless args.size == 0
        @params[key]
      end
    end

    def respond_to?(*args); true; end

    def update_attributes(params)
      @params.merge!(params)
      stringify_keys!
      save
    end

    def stringify_keys!
      @params.keys.each do |key|
        @params[key.to_s] = @params.delete(key)
      end
      @params
    end
  end
end
