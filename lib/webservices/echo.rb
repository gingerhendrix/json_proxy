
# Not needed but the test should be a little more robust this way
class EchoResponse
  attr_accessor :message
  
  def initialize(msg)
    @message = msg
  end 
end

np_namespace "echo" do |ns|
  
  ns.route 'echo', [:message] do |message|
    EchoResponse.new message
  end
end
