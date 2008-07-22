
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
          handler = RouteHandler.new(@namespace, name, arg_names, options, block)
          NamespaceManager.instance.register_handler(@namespace, name, handler)
       end
    end
  
  
  end
end
