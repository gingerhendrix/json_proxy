
module Server
 class RouteHandler
    def initialize(namespace, name, arg_names, options={}, block = Proc.new)
      @options = options
      @block = block
      @arg_names = arg_names
      @name = name
      @namespace = namespace
    end      
    
    def action(request, response)
      response.body = _action request.params
    end

private
    
    def _action(params)
      @params = HashWithIndifferentAccess.new params
      @args = @arg_names.map { |a| @params[a.to_s] }
      puts "Params: #{@params}\n Arg_names: #{@arg_names}\nArgs: #{@args}"
      result = nil
      begin
        result = cache do
          json @block.call(*@args)
        end 
        json_padding result          
      rescue Exception => e
        json_padding :error => "Error: " + e 
      end
    end
  
    
    def json(response)
      response.to_json
    end
    
    def json_padding(response)
      response_text = (response.is_a?(String) ? response : response.to_json)
      if @params[:jsonp]
        puts "#{@namespace}/#{@name} #{@args} jsonp: #{@params['jsonp']} \n"
        out = @params['jsonp'] + "(" + response_text + ")"
      else
        out = "(" + response_text + ")"
      end
      out
    end
    
    def cache(&block)
      cache = ::Utils::CouchCache.new "#{@namespace.downcase}_#{@name.downcase}"
      if @options[:cache]
         raise "Invalid cache_key: should be a Proc" unless @options[:cache_key] && @options[:cache_key].is_a?(Proc)
         key = @options[:cache_key].call *@args
         result = cache.fetch key
         if result.nil?
           result = yield
           cache.store key, result
         end
      else
         result = yield
      end
      result            
    end
  end
end
