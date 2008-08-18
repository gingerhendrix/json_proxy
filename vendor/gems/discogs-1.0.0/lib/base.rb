require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'zlib'
require 'cgi'
require 'yaml'

module Discogs
  class Base
    attr_accessor :api_key, :request_type, :request_string

    DISCOGS_BASE_URL = 'http://www.discogs.com'

    def initialize(request_string = nil, request_type = :artist)
      @api_key = load_api_key
      @request_string = request_string
      @request_type = request_type.to_s
    end

    def parsed
      @parsed ||= Hpricot.XML(fetched)
    end

    def fetched
      @fetched ||= begin
        gz = Zlib::GzipReader.new(open(request_url, 'Accept-encoding' => 'gzip, deflate'))
        fetched = gz.read
        gz.close
        fetched
      end
    end

    protected
      def request_url
        "#{DISCOGS_BASE_URL}/#{request_type}/#{CGI::escape(request_string)}?f=xml&api_key=#{api_key}"
      end

      def load_api_key
        begin
          YAML::load(open(config_file))[:api_key]
        rescue Errno::ENOENT
          File.open(config_file, 'w') do |file|
            file.write({:api_key => "CHANGE ME"}.to_yaml)
            puts "Please edit #{config_file}"
          end
        end
      end
      
      def home_dir
        ENV['HOME'] || ENV['USERPROFILE'] || ENV['HOMEPATH']
      end

      def config_filename(rails = false)
        rails ? 'discogs.yml' : '.discogs'
      end

      def config_file
        if defined?(RAILS_ROOT)
          File.join(RAILS_ROOT, 'config', config_filename)
        else
          File.join(home_dir, config_filename)
        end
      end
  end
end
