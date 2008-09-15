
require 'rubygems'
require 'rack'
require 'activesupport'
require 'configatron'

module JSON
  def self.parse(json)
    ActiveSupport::JSON.decode(json)
  end
end

require File.dirname(__FILE__) + '/config/config.rb'

require File.dirname(__FILE__) + '/lib/server/handlers/handler.rb'
require File.dirname(__FILE__) + '/lib/server/handlers/argument_validation_handler.rb'
require File.dirname(__FILE__) + '/lib/server/handlers/cache_handler.rb'
require File.dirname(__FILE__) + '/lib/server/handlers/exception_handler.rb'
require File.dirname(__FILE__) + '/lib/server/handlers/json_handler.rb'

require File.dirname(__FILE__) + '/lib/server/server.rb'
require File.dirname(__FILE__) + '/lib/server/route.rb'
require File.dirname(__FILE__) + '/lib/server/route_manager.rb'
require File.dirname(__FILE__) + '/lib/server/dsl.rb'



require File.dirname(__FILE__) + '/lib/utils/couch_cache.rb'
require File.dirname(__FILE__) + '/lib/utils/couch_server.rb'

require File.dirname(__FILE__) + '/vendor/gems/scrobbler-0.1.1/lib/scrobbler.rb'
require File.dirname(__FILE__) + '/vendor/gems/mbleigh-mash-0.0.5/lib/mash.rb'
require File.dirname(__FILE__) + '/vendor/gems/mbleigh-ruby-github-0.0.4/lib/ruby-github.rb'
require File.dirname(__FILE__) + '/vendor/gems/rbrainz-0.4.0/lib/rbrainz.rb'
require File.dirname(__FILE__) + '/vendor/gems/discogs-1.0.0/lib/discogs.rb'

app = Rack::ShowExceptions.new Rack::Reloader.new Server::Server.new 

include Server::DSL

require File.dirname(__FILE__) + '/lib/webservices/audioscrobbler.rb'
require File.dirname(__FILE__) + "/lib/webservices/musicbrainz.rb"
require File.dirname(__FILE__) + "/lib/webservices/wikipedia.rb"
require File.dirname(__FILE__) + "/lib/webservices/github.rb"
require File.dirname(__FILE__) + "/lib/webservices/discogs.rb"

Rack::Handler::Mongrel.run(app, :Port => 4567) do |server|
  puts "==  json_proxy running on port 4567"
  trap("INT") do
    puts "\n== Good night."
    exit()
  end
end

