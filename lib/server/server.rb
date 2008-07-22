
module Server
  class Server 
  
    def initialize
      @namespace_manager = NamespaceManager.instance
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
end
