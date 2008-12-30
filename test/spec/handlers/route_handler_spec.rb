require File.dirname(__FILE__) + '/../spec_helper'


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
 
 it "should not alter handler2 " do
   action
   handler2 = Server::Handlers::RouteHandler.new @namespace, @name, @options, @block
   handler2.method(:route).should raise_error(NameError)
   @handler.method(:route).should_not be_nil
 end



end