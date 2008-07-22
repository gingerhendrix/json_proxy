
module Server
  module DSL
  
    def np_namespace(name)
      yield Namespace.new(name)    
    end
    
    class Namespace
       def initialize(name)
            @namespace = name 
       end        
                    
       def route(name, arg_names, options={}, &block)
          route = Route.new(@namespace, name, arg_names, options, block)
          RouteManager.instance.register_route(@namespace, name, route)
       end
    end
  
  end
end
