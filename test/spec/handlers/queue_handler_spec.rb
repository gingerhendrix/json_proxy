require File.dirname(__FILE__) + '/../spec_helper'

describe  "QueueHandler#initialize" do
    it "should create a queue" do
      UrlQueue::UrlQueue.should_receive(:new)
      Server::Handlers::QueueHandler.new mock('name'), mock('namespace'), mock('options')
    end
 end


describe "Queue Handler#action" do


 before(:each) do
    @handler = Server::Handlers::QueueHandler.new mock('name'), mock('namespace'), mock('options')
    @queue = mock("queue")
    @handler.instance_variable_set("@queue", @queue)
    @request = mock("request")
    @response = mock("response")
    @block_body = mock("block_body")
    @block_body.stub!(:yielded)
 end

 def action
   @handler.action @request, @response do |request, response|
      @block_body.yielded request, response
    end
 end
 
 
 it "should call request.force?" do
   @request.should_receive('force?').and_return(true)
   action
 end
  
 describe "with force?" do
  before(:each) do
   @request.stub!('force?').and_return(true)
  end
  
  it "should yield to the next handler" do
    @request.should_receive('force?').and_return(true)
    @block_body.should_receive(:yielded).with(@request, @response)
    action  
  end
  
 end
 
 describe "not with force?" do
   before(:each) do
    @request.stub!('force?').and_return(false)
    @request.stub!(:url)
    @response.stub!(:status=)
    @response.stub!(:message=)
    @queue.stub!(:add)
   end
 
    it "should set response status to 202" do
      @response.should_receive(:status=).with(202)
      action
    end
    
    it "should set response message to 'Processing.  Please retry your request shortly'" do
      @response.should_receive(:message=).with('Processing.  Please retry your request shortly')
      action
    end
    
    it "should add the url to the queue" do
      @request.should_receive(:url).with({:force => true}).and_return(:url)
      @queue.should_receive(:add).with(:url)
      action            
    end
 end
end
