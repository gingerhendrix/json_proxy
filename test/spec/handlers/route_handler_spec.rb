require File.dirname(__FILE__) + '/../spec_helper'


describe "RouteHandler#get" do
  before do
    @handler = Server::Handlers::RouteHandler.new "namespace", "name", {} , Proc.new { }
    @request = mock('request', :host => "HOST", :port => "PORT")
    @handler.instance_variable_set('@request', @request)
    URI.stub!(:parse).and_return(:uri)
    Net::HTTP.stub!(:get_response).and_return(:response)
  end
  
  it "should construct URI" do
    URI.should_receive(:parse).with("http://HOST:PORT/namespace/service.js")
    @handler.get('service')
  end
  
  it "should construct URI with params" do
    URI.should_receive(:parse).with("http://HOST:PORT/namespace/service.js?param2=value&param=value")
    @handler.get('service', {:param => 'value', :param2 => 'value'})
  end

  
  it "should call Net:HTTP" do
    Net::HTTP.should_receive(:get_response).with(:uri).and_return(:response)
    @handler.get('service').should == :response
  end
end

describe "RouteHandler#action" do


 before(:each) do
    @name = 'name'
    @namespace = 'namespace'
    @options = mock("options")

    @block_body = mock("block_body")
    @block_body.stub!(:yielded)
    @block_body.stub!(:in_context)
    
    
    @block = Proc.new { |*args|
      @block_body.yielded *args
      @block_body.in_context self
      :block_return
    }
        
    @handler = Server::Handlers::RouteHandler.new @namespace, @name, @options, @block
    @handler.instance_variable_set(:@block_body, @block_body)
    
    @request = mock("request")
    @request.stub!(:args)
   
    @response = mock("response")
    @response.stub!(:body=)
 end
 
 def action
   @handler.action @request, @response
 end
 
 it "should set request instance variable" do
   action
   @handler.instance_variable_get(:@request).should be(@request)
 end
 
 it "should set response instance variable" do
   action
   @handler.instance_variable_get(:@response).should be(@response)
 end
 
 it "should execute block with request args" do
   @request.should_receive(:args).and_return(:request_args)
   @block_body.should_receive(:yielded).with(:request_args)
   action
 end
 
 it "should execute block in the handlers context" do
   @block_body.should_receive(:in_context).with(@handler)
   action
 end
 
 it "should set the response body to the block return" do
   @response.should_receive(:body=).with(:block_return)
   action
 end
 
 # Ugly test that tricky metdata hackery doesn't have unwanted side effects 
 it "should not alter handler2 " do
   action
   handler2 = Server::Handlers::RouteHandler.new @namespace, @name, @options, @block
   handler2.method(:route).should raise_error(NameError)
   @handler.method(:route).should_not be_nil
 end

  describe "when an exception is thrown" do
    before(:each) do
      @exception = RuntimeError.new
      @block_body.stub!(:yielded).and_raise(@exception)
      @response.stub!(:status=)
      @response.stub!(:errors).and_return([])
    end
    
  
    it "should be caught" do
      lambda{ action }.should_not raise_error
    end
    
    it "should set staus to 500" do
      @response.should_receive(:status=).with(500)
      action
    end
    
    it "should add exception to response.errors" do
      errors = mock("errors")
      @response.should_receive(:errors).and_return(errors)
      errors.should_receive(:<<).with(@exception)
      action
    end
  
  end

end
