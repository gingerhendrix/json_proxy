module Discogs
  class Label < Base
    attr_accessor :name, :images, :contact_info, :profile, :urls, :parent, :sublabels, :releases

    def initialize(request_string)
      @request_string = request_string
      super(@request_string, 'label')
    end

    def label
      @label ||= (parsed/'label')
    end

    def name
      @name ||= (label/'name').inner_html
    end

    def images
      @images ||= (label/'images'/'image').collect do |image| 
        Image.new(image.attributes['url'], 
                  image.attributes['type'],
                  image.attributes['uri150'],
                  image.attributes['width'],
                  image.attributes['height'])
      end
    end

    def contact_info
      @contact_info ||= (label/'contactinfo').inner_html
    end

    def profile
      @profile ||= (label/'profile').inner_html
    end

    def urls
      @url ||= (label/'urls'/'url').collect { |url | url.inner_html }
    end

    def parent
      @parent_label ||= begin
        Label.new((label/'parentLabel').inner_html) unless (label/'parentLabel').empty?
      rescue
      end
    end

    def sublabels
      @sub_labels ||= begin
        (label/'sublabels'/'label').collect do |label| 
          label = label.inner_html
          Label.new(label) unless label.empty?
        end
      rescue
      end
    end

    def releases
      @releases ||= begin
        (label/'releases'/'release').collect do |release| 
          Release.new(release.attributes['id']) unless release.attributes['id'].empty?
        end
      rescue
      end
    end

    def to_s
      name
    end
  end
end
