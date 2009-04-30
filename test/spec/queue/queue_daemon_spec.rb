require File.dirname(__FILE__) + '/../spec_helper'


describe "QueueDaemon" do
  
  before(:each) do
    @q = mock("Queue")
    @urls = ["http://example.com/1", "http://example.com/2"]
    @daemon = UrlQueue::QueueDaemon.new
    @daemon.instance_variable_set('@q',@q)
  end
  
  it "fetch urls from queue" do
    @q.should_receive(:get).exactly(3).times.and_return(@urls[0], @urls[1], nil)
    Net::HTTP.should_receive(:get_response).twice()
    @daemon.process
  end
  
end
