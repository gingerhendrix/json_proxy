
require 'rubygems'
require 'rack'



class JsonProxyServer 
  
  def initialize(namespace_manager)
    @namespace_manager = namespace_manager
  end

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new()
    
    handler = @namespace_manager.handler_for(request.path_info);
    if(!handler)
      response.body = "Handler not found"
    else
      handler.action(request, response)
    end
    
    response.finish
  end

end

class NamespaceManager

  def handler_for(path)
    
  end

  def register_handler
  
  end

end

ns_manager = NamespaceManager.new
app = JsonProxyServer.new ns_manager

Rack::Handler::Mongrel.run(app, :Port => 3000) do |server|
  puts "==  json_proxy running on port 3000"
  trap("INT") do
    puts "\n== Good night."
    exit()
  end
end

