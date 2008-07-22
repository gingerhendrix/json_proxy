
require 'rubygems'
require 'rack'
require 'activesupport'

require File.dirname(__FILE__) + '/lib/server/server.rb'
require File.dirname(__FILE__) + '/lib/server/namespace_manager.rb'
require File.dirname(__FILE__) + '/lib/server/route_handler.rb'
require File.dirname(__FILE__) + '/lib/server/dsl.rb'

require File.dirname(__FILE__) + '/lib/utils/couch_cache.rb'
require File.dirname(__FILE__) + '/lib/utils/couch_server.rb'

require File.dirname(__FILE__) + '/vendor/gems/scrobbler-0.1.1/lib/scrobbler.rb'

app = Rack::ShowExceptions.new Server::Server.new 

include Server::DSL

require File.dirname(__FILE__) + '/lib/webservices/audioscrobbler.rb'


Rack::Handler::Mongrel.run(app, :Port => 3000) do |server|
  puts "==  json_proxy running on port 3000"
  trap("INT") do
    puts "\n== Good night."
    exit()
  end
end

