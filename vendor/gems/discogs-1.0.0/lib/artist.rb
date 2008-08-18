module Discogs
  class Artist < Base
  
    attr_accessor :name,
                  :members,
                  :urls,
                  :releases,
                  :images,
                  :realname

    def name
      @name ||= (parsed/'artist'/'name').first.inner_html
    end

    def realname
      @realname ||= (parsed/'artist'/'realname').first.inner_html
    end

    def members
      @members ||= (parsed/'artist'/'members'/'name').collect { |artist| artist.inner_html }
    end

    def images
      @images ||= (parsed/'artist'/'images'/'image').collect do |image|
        Image.new(image.attributes['url'], 
                  image.attributes['type'],
                  image.attributes['uri150'],
                  image.attributes['width'],
                  image.attributes['height'])
      end
    end

    def urls
      @urls ||= (parsed/'artist'/'urls').collect { |url| (url/'url').inner_html }
    end

    def releases
      @release ||= (parsed/'artist'/'releases'/'release').collect do |release| 
        Release.new(api_key, release.attributes['id']) 
      end
    end

    def to_s
      name
    end
  end
end
