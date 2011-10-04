require 'cubbyhole/collection'

module Cubbyhole
  class Base
    METHOD_BLACKLIST = [:marshal_load, :marshal_dump, :_dump, :_load]

    def self.create(params={})
      new(params).save
    end

    def self.get(id)
      backend[id.to_s]
    end

    def self.get!(id)
      get(id) or raise "#{self.class} not found for id #{id}"
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

    def self.first(atts = nil)
      all(atts).first
    end

    def self.last(atts = nil)
      all(atts).last
    end

    def self.all(atts = nil)
      Collection.new(backend.keys.sort_by(&:to_i).map{|k| backend[k] }).all(atts)
    end

    def self.backend
      require 'cubbyhole/sdbm'
      @backend ||= SDBM.new(self.to_s)
    end

    def self.nuke
      backend.clear
    end

    def initialize(params={})
      @id = self.class.next_id
      @params = params
      @persisted = false
      normalize_params!
    end

    attr_reader :id

    def persisted?
      @persisted
    end

    def save
      @persisted = true
      normalize_params!
      self.class.backend[id.to_s] = self
      self
    end

    def destroy
      self.class.backend.delete(@id.to_s)
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

    def attributes
      @params.dup
    end

    def update_attributes(params)
      @params.merge!(params)
      normalize_params!
      save
    end

    def normalize_params!
      @params.default = nil

      @params.keys.dup.each do |key|
        @params[key.to_s] = @params.delete(key)
      end
      @params
    end
  end
end
