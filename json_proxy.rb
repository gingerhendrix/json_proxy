
require File.dirname(__FILE__) + '/vendor/gems/sinatra-0.1.7/lib/sinatra.rb'
require File.dirname(__FILE__) + '/vendor/gems/scrobbler-0.1.1/lib/scrobbler.rb'

require File.dirname(__FILE__) + '/vendor/gems/mbleigh-mash-0.0.5/lib/mash.rb'
require File.dirname(__FILE__) + '/vendor/gems/mbleigh-ruby-github-0.0.4/lib/ruby-github.rb'

require 'rbrainz'
require 'hpricot'
require 'open-uri'
require 'fileutils'

FileUtils.cd File.dirname(__FILE__)

Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/utils/cache.rb"
Utils::Cache.base_dir = File.dirname(__FILE__) + '/cache'

Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/utils/jsonp_renderer.rb"
Sinatra::EventContext.send :include, NowPlaying::Utils::JsonpRenderer

Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/utils/routes.rb"
include NowPlaying::Utils::Routes

Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/webservices/audioscrobbler.rb"
Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/webservices/musicbrainz.rb"
Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/webservices/wikipedia.rb"
Sinatra::Loader.load_files File.dirname(__FILE__) + "/lib/webservices/github.rb"

get '/' do
   erb File.open("index.html").read
end

