
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
require File.dirname(__FILE__) + '/lib/json_proxy.rb'
include Server::DSL
require File.dirname(__FILE__) + "/lib/webservices/echo.rb"

# Rack::ShowExceptions.new
app = Rack::Reloader.new Server::Server.new 

Rack::Handler::Mongrel.run(app, :Port => 4567) do |server|
  puts "==  json_proxy running on port 4567"
  trap("INT") do
    puts "\n== Good night."
    exit()
  end
end

