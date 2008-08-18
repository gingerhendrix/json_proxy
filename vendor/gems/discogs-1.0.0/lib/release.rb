module Discogs
  class Release < Base

    attr_accessor :discog_id, 
                  :title, 
                  :label, 
                  :format, 
                  :discog_status, 
                  :genres, 
                  :styles, 
                  :formats, 
                  :labels, 
                  :country, 
                  :released, 
                  :tracks, 
                  :images, 
                  :contributors

    def initialize(discog_id)
      @discog_id = discog_id
      super
    end

    def discog_status
      @discog_status ||= (parsed/'release').first.attributes['status']
    end

    def title
      @title ||= (parsed/'title').first.inner_html
    end

    def labels
      @labels ||= (parsed/'labels'/'label').collect { |label| label.attributes['name'] }
    end

    def genres
      @genres ||= (parsed/'genres'/'genre').collect { |genre| genre.inner_html }
    end

    def styles
      @styles ||= (parsed/'styles'/'style').collect{ |label| label.inner_html }
    end

    def country
      @country ||= (parsed/'country').inner_html
    end

    def released
      @released ||= (parsed/'released').inner_html
    end

    def formats
      @formats ||= (parsed/'formats'/'format').collect do |format| 
        Format.new(format.attributes['name'], format.attributes['qty'])
      end
    end

    def tracks
      @tracks ||= (parsed/'tracklist'/'track').collect do |track|
        Track.new((track/'position').inner_html,
                  (track/'title').inner_html,
                  (track/'duration').inner_html
        )
      end
    end

    def images
      @images ||= (parsed/'images'/'image').collect do |image|
        Image.new(image.attributes['url'], 
                  image.attributes['type'],
                  image.attributes['uri150'],
                  image.attributes['width'],
                  image.attributes['height'])
      end
    end

    def contributors
      @contributors ||= (parsed/'extraartists'/'artist').collect do |artist| 
        Contributor.new((artist/'name').inner_html, (artist/'role').inner_html)
      end
    end

    def to_s
      "#{title} - #{label} - #{released} - #{format}"
    end

    protected
      def request_url
        "#{DISCOGS_BASE_URL}/release/#{discog_id}?f=xml&api_key=#{api_key}"
      end
  end
end
