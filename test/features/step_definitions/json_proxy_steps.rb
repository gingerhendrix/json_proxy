require 'rubygems'
require 'net/http'
require 'active_support'

require 'rubygems'
require 'spec'
require 'configatron'


$:.unshift(File.dirname(__FILE__) + "/../../../lib") 
require 'json_proxy'
require 'queue/queue'
require 'queue/queue_daemon'

require File.dirname(__FILE__) + '/test_service.rb'

SERVER_PORT = 13233

def start_server
  app = Server::Server.new 
  Thread.new {
     @acc = Rack::Handler::Mongrel.run(app, :Port => SERVER_PORT) do |server|
      puts "Server running"     
     end
   }
  sleep 2
end
  
def start_worker
  Thread.new {
    puts "Worker Started"
    worker = UrlQueue::QueueDaemon.new
    sleeping = false
    loop do
      processed = worker.process
      if processed == 0 && !sleeping
        sleeping = true
        puts "Queue empty \n"
      elsif processed > 0
        puts "Processed #{processed}\n"
        sleeping = false
      end
     sleep(1)
    end
  }
  sleep 1
end

def random_msg
  "random-#{rand(9999999)}"
end

def echo_get(msg)
  Net::HTTP.get_response(URI.parse("http://localhost:#{SERVER_PORT}/echo/echo.js?message=#{msg}"))
end

def echo_force_get(msg)
  Net::HTTP.get_response(URI.parse("http://localhost:#{SERVER_PORT}/echo/echo.js?message=#{msg}&force=true"))
end

def unknown_get
  Net::HTTP.get_response(URI.parse("http://localhost:#{SERVER_PORT}/unknown/unknown.js"))
end

def exception_get(msg)
  Net::HTTP.get_response(URI.parse("http://localhost:#{SERVER_PORT}/echo/exception.js?message=#{msg}"))
end

def poll
    count = 0
  maxCount = 10
  while @response = yield
    if (@response.code != "202")
      break
    end
    if count > maxCount
      fail("Too many retries")
      break
    end
    count += 1
    sleep(1)
  end
end

start_server
start_worker

Given /^a server with an echo service$/ do
    #Not required - server started globally
end

Given /^a server$/ do
    #Not required - server started globally
end

Given /^a server with an exception throwing service$/ do
    #Not required - server started globally
end

Given /^a cached message$/ do
  @message = random_msg
  echo_force_get @message
end

When /^the user retrieves the message$/ do
  @response = echo_get(@message)
end

Then /^the server should return the message$/ do
  @response.code.should == "200"
  body = ActiveSupport::JSON.decode(@response.body)
  body.should be :kind_of, Hash
  body['status'].should == 200
  body['data'].should be :kind_of, Hash
  body['data']['message'].should == @message
end

Given /^an uncached message$/ do
  @message = random_msg
end

Then /^the server should return a processing response$/ do
  @response.code.should == "202"
  @response.body.should_not be(:empty)
  body = ActiveSupport::JSON.decode(@response.body)
  body.should be :kind_of, Hash
  body['status'].should == 202
end

When /^the user polls the service$/ do
  poll do 
    echo_get(@message) 
  end
end

When /^the user force retrieves the message$/ do
  @response = echo_force_get(@message)
end

When /^the user requests an unkown service$/ do
  @response = unknown_get
end

Then /^the server should return a 404 response$/ do
  pending "Hmmm" do
    response.code.should =="404"
    response.body.should =="Handler not found"
  end
end

When /^the user polls the exception throwing service$/ do
  poll do 
    exception_get(@message) 
  end
end

Then /^the server should eventualy return an error response$/ do
  @response.code.should == "500"
  body = ActiveSupport::JSON.decode(@response.body)
  body['status'].should == 500
  body['errors'].should be :kind_of, Array
  body['errors'][0].should be_kind_of Hash
  error = body['errors'][0]
  error['name'].should == "StandardError"
  error['message'].should == "message-#{@message}"        
  error['backtrace'].should be_kind_of(Array)
end





