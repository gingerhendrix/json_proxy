require File.dirname(__FILE__) + '/../spec_helper'

require File.dirname(__FILE__) + '/../../../lib/utils/cache'


describe "Cache" do
  before(:each) do
    Utils::Cache.base_dir = File.dirname(__FILE__) + '/../../../cache'
  end
  
  it "should raise exception if base_dir does not exist" do
    begin
      Utils::Cache.base_dir = ""
      cache = Utils::Cache.new "test"
      fail "should throw error if base_dir not set  "
    rescue
    end
  end

  it "should run create prefix dirs" do
   cache = Utils::Cache.new "test"
   cache.store("key", "value")
  end
  
end
