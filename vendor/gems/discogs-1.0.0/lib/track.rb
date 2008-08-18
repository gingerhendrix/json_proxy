module Discogs
  class Track
    attr_accessor :position,
                  :title,
                  :duration

    def initialize(position, title, duration)
      @position = position
      @title = title
      @duration = duration
    end
    
    def to_s
      title
    end
  end
end
