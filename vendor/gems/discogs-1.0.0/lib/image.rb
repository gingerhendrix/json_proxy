module Discogs
  class Image

    attr_accessor :uri, 
                  :type, 
                  :uri150, 
                  :width, 
                  :height

    def initialize(uri, type, uri150, width, height)
      @uri = uri
      @type = type
      @uri150 = uri150
      @width = width
      @height = height
    end

    def to_s
      uri
    end
  end
end
