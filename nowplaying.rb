
require File.dirname(__FILE__) + '/vendor/gems/sinatra-0.1.7/lib/sinatra.rb'
require File.dirname(__FILE__) + '/vendor/gems/scrobbler-0.1.1/lib/scrobbler.rb'

require 'rbrainz'
require 'hpricot'
require 'open-uri'

Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/utils/jsonp_renderer.rb"

Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/audioscrobbler/routes.rb"
Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/musicbrainz/routes.rb"
Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/wikipedia/routes.rb"

Sinatra::EventContext.send :include, NowPlaying::Utils::JsonpRenderer

module NowPlaying
  module Routes
    get '/' do
      File.open("nowplaying.html").read
    end

    static '/static', 'static'
  end
end

