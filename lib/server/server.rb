
module Server
  class Server 
  
    def initialize
      @route_manager = RouteManager.instance
    end

    def call(env)
      request = Rack::Request.new(env)
      class << request
        alias_method :orig_params, :params
        def params
          @indifferent_params ||= HashWithIndifferentAccess.new orig_params
        end
      end
      response = Rack::Response.new()
      
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
