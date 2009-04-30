require File.dirname(__FILE__) + '/../spec_helper'

#
# TODO: OMGWTF - These tests smell worse than next door neighbours extractor vent.
#              - The class under test is probably nearly as bad.
#              - Sure you got enough mocks?
describe "Cache Handler#action" do


 before(:each) do
    @name = 'name'
    @namespace = 'namespace'
    @options = mock("options")
    @options.stub!('[]').with(:cache_key).and_return(Proc.new { "key" })
    @handler = Server::Handlers::CacheHandler.new @namespace, @name, @options
    
    @cache = mock("cache")
    @cache.stub!(:fetch)
    Utils::CouchCache.stub!(:new).and_return(@cache)
    
    @request = mock("request")
    @request.stub!(:args)
    @request.stub!(:force?)
    @response = mock("response")
    
    @errors = mock("errors")
 	   
    @response.stub!(:errors).and_return(@errors)
    @response.stub!(:status=)

    @block_body = mock("block_body")
    @block_body.stub!(:yielded)
 end

 def action
   @handler.action @request, @response do |request, response|
      @block_body.yielded request, response
   end
 end
 
 it "should initialise cache" do
   Utils::CouchCache.should_receive(:new).with("#{@namespace.downcase}_#{@name.downcase}")
   action
 end
 
 it "should raise exception if cache_key is not a proc" do
  cache_key = mock("cache_key")
  @options.stub!('[]').with(:cache_key).and_return(cache_key)
  cache_key.should_receive(:is_a?).with(Proc).and_return(false)

  lambda { action }.should raise_error
  
 end
 
 it "should apply the cache_key function to the request args" do
  args = mock("args")
  cache_key_body = mock("cache_key_body")
  cache_key = Proc.new { |args| cache_key_body.yielded args }
  
  @options.stub!('[]').with(:cache_key).and_return(cache_key)
  cache_key_body.should_receive(:yielded).with(args)
  @request.stub!(:args).and_return(args)
  
  action
 end
 
 it "should fetch the result from the cache" do
  @cache.should_receive(:fetch).with("key")
  
  action
 end
 
 describe ", cache miss" do
    before(:each) do
      @cache.stub!(:fetch).and_return(nil)
    end

    it "should yield" do
      @block_body.should_receive(:yielded).with(@request, @response)
      
      action
    end

    it "should check if the request is forced" do
      @request.should_receive(:force?)
      
      action
    end

    describe "with unforced request" do
      before(:each) do
        @request.stub!(:force?).and_return(false)
      end
      
      it "should not store result" do
         @cache.should_not_receive(:store)
         action
      end
      
    end

    describe "with forced request" do
       before(:each) do
        @request.stub!(:force?).and_return(true)
       end
      
      it "should store result" do
        body = {}
        errors = [StandardError.new]
        @response.should_receive(:body).and_return(body)
        @response.should_receive(:errors).and_return(errors)
        
        @cache.should_receive(:store).with("key", anything())  do |key , json|
          cacheObj = JSON.parse json
          cacheObj['mtime'].should be_kind_of(Numeric)
          cacheObj['ctime'].should be_kind_of(Numeric)
          cacheObj['app_version'].should be(JsonProxy::APP_VERSION)
          cacheObj['errors'].should be_kind_of(Array)
          cacheObj['data'].should be_kind_of(Hash)
        end
         action
      end
    end
  end
  
  describe ", cache hit" do
    before(:each) do
      @cacheObj = mock("cacheObj")
      @cacheObj.stub!('[]').with('data')
      @cacheObj.stub!('[]').with('mtime')
      @cacheObj.stub!(:[]).with('errors').and_return([:errors])
      
      @handler.stub!(:expired?).and_return(false)
      @cache.stub!(:fetch).and_return("cacheJSON")
      
      JSON.stub!(:parse).with("cacheJSON").and_return(@cacheObj)
      
      @response.stub!(:body=)
      @errors.stub!(:concat)
    end
  
    it "should parse JSON result" do
      JSON.should_receive(:parse).with("cacheJSON")
      action
    end
  
    it "should check expiry" do

      @handler.should_receive(:expired?).with(@cacheObj)
      action
    end  
    
    describe "with unexpired cached result" do
      before(:each) do
         @handler.stub!(:expired?).and_return(false)
      end
      
      it "should set the response" do
        @cacheObj.should_receive('[]').with('data').and_return(:data)
        @response.should_receive(:body=).with(:data)
        action
      end
      
      it "should combine the errors" do
        @cacheObj.should_receive('[]').with('errors').and_return([:errors])
        @errors.should_receive(:concat).with([:errors])
        action
      end
      
      it "should set the status to 500 if there are errors" do
        @cacheObj.should_receive('[]').with('errors').and_return([:errors])
        @response.should_receive('status=').with(500)
        action

      end
      
      it "should not yield" do
        @block_body.should_not_receive(:yielded)
        action
      end
    
    end
    
    describe "with expired cache result" do
      before(:each) do
         @handler.stub!(:expired?).and_return(true)
      end
      
       it "should yield" do
         @block_body.should_receive(:yielded).with(@request, @response)
         action
       end

       describe "with unforced request" do

         before(:each) do
           @request.stub!(:force?).and_return(false)
        end
               
        it "should not store result" do
          @cache.should_not_receive(:store)
          action
        end
      end
       
       describe "with forced request" do

         before(:each) do
           @request.stub!(:force?).and_return(true)
        end
               
        it "should store result" do
          body = {}
          errors = [StandardError.new]
          
          @response.should_receive(:body).and_return(body)
          @response.should_receive(:errors).and_return(errors)
          
          @cacheObj.should_receive('[]').with('ctime').and_return("ctime")
          @cacheObj.should_receive('[]').with('_id').and_return("id")
          @cacheObj.should_receive('[]').with('_rev').and_return("rev")
          
          @cache.should_receive(:store).with("key", anything())  do |key , json|
            cacheObj = JSON::Parser.new(json).parse #JSON.parse is stubbed
            cacheObj['ctime'].should =="ctime"
            cacheObj['mtime'].should be_kind_of(Numeric)
            cacheObj['app_version'].should be(JsonProxy::APP_VERSION)
            cacheObj['_rev'].should =="rev"
            cacheObj['_id'].should =="id"
            cacheObj['errors'].should be_kind_of(Array)
            cacheObj['data'].should be_kind_of(Hash)
          end
           action
        end
      end
    end
        
  end
end
