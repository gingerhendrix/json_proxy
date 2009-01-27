require File.dirname(__FILE__) + '/../spec_helper'

class Dummy
  attr_accessor :atrr1
  attr_accessor :atrr2  
  
  def initialize(a1, a2)
    @attr1 = a1
    @attr2 = a2
  end
  
  
end

describe "JSON" do

  it "should correctly serialize a hash" do
    test_obj = HashWithIndifferentAccess.new  :prop1 => "Blah", :prop2 => 3, :prop4 => nil #Propnames get serialized as strings but we don't care
    deserialized_obj = JSON.parse test_obj.to_json
    deserialized_obj.should ==test_obj
  end
  
  it "should correctly serialize an object" do
    test_obj = Dummy.new "blah", 3
    deserialized_obj = JSON.parse test_obj.to_json
    deserialized_obj.should == {"attr1" => "blah", "attr2" => 3}
  end
  
  it "should correctly serialize an array" do
    test_obj = ["one", "two", "three"]
    deserialized_obj = JSON.parse test_obj.to_json
    deserialized_obj.should == test_obj
  end
  
  it "should correctly serialize an Exception" do
    test_obj = StandardError.new
    deserialized_obj = JSON.parse test_obj.to_json
    deserialized_obj.should == {"exception" => "Message"}
  end
  
  it "should correctly serialize a hash containing an array" do
    test_obj = HashWithIndifferentAccess.new :prop1 => ["one", "two", "three"]
    deserialized_obj = JSON.parse test_obj.to_json
    deserialized_obj.should == test_obj
  end
  
  it "should correctly serialize a hash containing objects" do
    test_obj = { :objProp => Dummy.new("blah", 3), :otherProp => "woo" }
    deserialized_obj = JSON.parse test_obj.to_json
    deserialized_obj.should == {"objProp" => {"attr1" => "blah", "attr2" => 3}, "otherProp" => "woo"}

  end

end
