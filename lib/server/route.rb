
module Server
  class Route
     def initialize(namespace, name, arg_names, options={}, block = Proc.new)
      @options = options
      @block = block
      @arg_names = arg_names
      @name = name
      @namespace = namespace
     end
     
     def action(request, response)
        handler = RouteHandler.new(@namespace, @name, @arg_names, @options, @block)
        handler.action(request, response)
     end     
  end
end
