require File.dirname(__FILE__) + '/../spec_helper'

describe "Queue" do
  
  it "should queue urls" do
    queue = UrlQueue::UrlQueue.new('test-queue');
    test_url = "http://localhost/echo?message=blah"
    queue.get.should be_nil
    queue.add(test_url)
    queue.get.should == test_url
    queue.get.should be_nil
  end
  
end


