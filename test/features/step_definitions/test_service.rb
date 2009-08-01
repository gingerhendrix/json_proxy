include Server::DSL

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
  
  ns.route 'exception', [:message] do |message|
    raise StandardError.new, "message-#{message}"
  end
  
  ns.route 'double_echo', [:message] do |message|
    response = get 'echo', :message => message
    if response.code == "200"
      #    body = ActiveSupport::JSON.decode(response.body)
      #    msg = body['data']['message']
      EchoResponse.new response.body
    else
      @response.partial!
    end
  end
  
end
