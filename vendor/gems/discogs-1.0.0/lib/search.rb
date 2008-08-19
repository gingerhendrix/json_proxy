module Discogs
  class Search < Base

    attr_accessor :exactresults, 
                  :results, 
                  :search_type, 
                  :exactresult_size, 
                  :result_size

    def initialize(request_string)
      @request_string = request_string
      @search_type = 'all' # search_type doesn't seem to make any difference as of API v 1.0
      super
    end

    def exactresult_size
      @exactresult_size ||= exactresults.size
    end

    def result_size
      (parsed/'searchresults').first.attributes['end'].to_i
    end

    def exactresults
      (parsed/'exactresults'/'result').collect do |result|
        SearchResult.new(
          result.attributes['type'],
          (result/'title').inner_html,
          (result/'uri').inner_html,
          (result/'summary').inner_html
        )
      end

    end

    def results
      (parsed/'searchresults'/'result').collect do |result|
        SearchResult.new(
          result.attributes['type'],
          (result/'title').inner_html,
          (result/'uri').inner_html,
          (result/'summary').inner_html
        )
      end
    end

    def best_match
      first_result = exactresults.first
      if first_result.artist?
        artist = Discogs::Artist.new(api_key, first_result.title)
        artist.releases[0,5]
      end
    end

    protected
      def request_url
        "#{base_url}/search?type=#{search_type}&q=#{CGI::escape(@request_string)}&f=xml&api_key=#{api_key}"
      end
  end

  class SearchResult
    attr_accessor :type,
                  :title,
                  :uri,
                  :summary

    def initialize(type, title, uri, summary = nil)
      @type = type
      @title = title
      @uri = uri
      @summary = summary
    end

    def method_missing(method, *args, &block)
      type = method.to_s.match(/([a-zA-Z0-9_-]+)\?/)
      # if type.size < 2 the method did not have a question mark at the end
      super if type.size < 2
      @type == type[1].to_s
    end

    def to_s
      "#{title}"
    end
    
  end
end
