
module Server
  module Handlers
    class RouteHandler < Handler
      def initialize(name, namespace, options, block)
         @block = block
         super(name, namespace, options)
      end
      
      def action(request, response)
        @request = request
        @response = response
 
        # Some serious metaclass hackery 
        # Aim is to execute block in context of this object, and with the specified arguments
        # Can't do both with proc.call or instance_eval 
        # Can't work out if this modifies self's class (i.e. RouteHandler or self's virtual class)
        
        self.class.send(:define_method, :route, @block)

        response.body = route *request.args
      end
    
    end
  
  end
end
