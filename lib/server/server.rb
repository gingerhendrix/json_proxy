
module Server
  class Server 
  
    def initialize
      @route_manager = RouteManager.instance
    end

    def call(env)
      request = JsonRequest.new(env)
      response = JsonResponse.new()
      
      route = @route_manager.route_for(request.path_info);
      if(!route)
        response.body = "Handler not found"
      else
        route.action(request, response)
      end
      
      response.finish
    end

  end
end
