module Cubbyhole
  class Collection < Array

    def last(atts = nil)
      if atts
        all(atts).last
      else
        super()
      end
    end

    def first(atts = nil)
      if atts
        all(atts).first
      else
        super()
      end
    end

    def all(atts = nil)
      if atts
        Collection.new(where(atts))
      else
        self
      end
    end

  private

    def where(atts)
      select do |item|
        matches = true
        atts.each do |k, v|
          if item.send(k).to_s != v.to_s
            matches = false
          end
        end
        matches
      end
    end

  end
end
