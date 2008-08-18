module Discogs
  class Format
    attr_accessor :name, :qty
    def initialize(name, qty)
      @name = name
      @qty = qty
    end

    def to_s
      name
    end
  end
end
