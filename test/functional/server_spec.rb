require 'rubygems'
require 'net/http'
require 'active_support'

require File.dirname(__FILE__) + '/spec_helper'

# Test basic server operation using echo server

describe "Server" do
  before(:each) do
  end
  
  def get(msg)
    Net::HTTP.get_response(URI.parse('http://localhost:4567/echo/echo.js?message='+msg))
  end
  
  def force_get(msg)
    Net::HTTP.get_response(URI.parse('http://localhost:4567/echo/echo.js?message='+msg+'&force=true'))
  end
  
  def random_msg
    "random-#{rand(9999999)}"
  end
  
  describe "with missing service" do
    it "response should be 404" do
      response = Net::HTTP.get_response(URI.parse('http://localhost:4567/missing'))
      response.code.should =="200"
      response.body.should =="Handler not found"
    end
  end

  describe "with echo service" do

    describe "with cached message" do
      before(:each) do
          force_get "cached"
      end
    
      it "response should == message " do
        response = get("cached")
        response.code.should == "200"
        body = ActiveSupport::JSON.decode(response.body)
        body.should be :kind_of, Hash
        body['status'].should == 200
        body['data'].should be :kind_of, Hash
        body['data']['message'].should == "cached" 
 
      end
   
    end
    
    describe "with uncached message" do
    
      it "response should be 202 - Processing until complete then success" do
        msg = random_msg
        response = get(msg)
        response.code.should == "202"
        response.body.should_not be(:empty)
        body = ActiveSupport::JSON.decode(response.body)
        body.should be :kind_of, Hash
        body['status'].should == 202
        count = 1;
        maxCount = 10;
        while response = get(msg)
          puts "Retry #{count} \n"
          if (response.code != "202" || count > maxCount)
            break
          end
          count += 1
          sleep(1)
        end
        response.code.should == "200"
        body = ActiveSupport::JSON.decode(response.body)
        body['status'].should == 200
        body['data'].should be :kind_of, Hash
        body['data']['message'].should == msg 
      end
   
    end
    
    describe "with forced query" do

      it "response should == message " do
        msg = random_msg
        response = force_get(msg)
        response.code.should == "200"
        body = ActiveSupport::JSON.decode(response.body)
        body['status'].should == 200
        body['data'].should be :kind_of, Hash
        body['data']['message'].should == msg 
      end
    
    end

  end
end
