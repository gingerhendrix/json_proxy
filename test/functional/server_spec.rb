require File.dirname(__FILE__) + '/spec_helper'

require 'net/http'
require 'active_support'
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
        body['message'].should == "cached" 
 
      end
   
    end
    
    describe "with uncached message" do
    
      it "response should be 202 - Processing " do
        msg = random_msg
        response = get(msg)
        response.code.should == "202"
      end
   
    end
    
    describe "with forced query" do

      it "response should == message " do
        msg = random_msg
        response = force_get(msg)
        response.code.should == "200"
        body = ActiveSupport::JSON.decode(response.body)
        body['message'].should == msg 
      end
    
    end

  end
end
