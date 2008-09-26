
module Server
  class Route
    include Handlers
    
     def initialize(namespace, name, arg_names, options={}, block = Proc.new)
      @name = name
      @namespace = namespace
      @options = options
      @block = block
      @options[:arg_names] = arg_names
     end
     
     def action(request, response)
        JsonHandler.new(@namespace, @name, @options).action(request, response) do |request, response|
          ExceptionHandler.new(@namespace, @name, @options).action(request, response) do |request, response|
            ArgumentValidationHandler.new(@namespace, @name, @options).action(request, response) do |request, response|
              CacheHandler.new(@namespace, @name, @options).action(request, response) do |request, response|
                QueueHandler.new(@namespace, @name, @options) do |request, response|
                    response.body = @block.call(*request.args)
                end
              end
            end
          end
        end
     end
          
  end
end
