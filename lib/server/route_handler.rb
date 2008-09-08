
module Server
 class RouteHandler
    def initialize(namespace, name, arg_names, options={}, block = Proc.new)
      @options = {:cache => true, :cache_key => Proc.new { |*args| args.join("_") } }.merge(options)
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
      begin
        @params = HashWithIndifferentAccess.new params
        missing = @arg_names.select { |a| @params[a.to_s].nil? || @params[a.to_s]=="" }
        if(missing.length > 0)
          raise "Missing arguments #{missing}"         
        end
        @args = @arg_names.map { |a| @params[a.to_s] }
        result = cache do
          json @block.call(*@args)
        end 
        json_padding result          
      rescue Exception => e
        puts "Exception: #{e} \n"
        pp e.backtrace 
        puts "\n"
        json_padding :error => "Error: " + e 
      end
    end
  
    
    def json(response)
      response.to_json
    end
    
    def json_padding(response)
      response_text = (response.is_a?(String) ? response : response.to_json)
      if @params[:jsonp]
        #puts "#{@namespace}/#{@name} #{@args} jsonp: #{@params['jsonp']} \n"
        out = @params['jsonp'] + "(" + response_text + ")"
      else
        out = "(" + response_text + ")"
      end
      out
    end
    
    def cache(&block)
      if @options[:cache]
         cache = ::Utils::CouchCache.new "#{@namespace.downcase}_#{@name.downcase}"
         raise "Invalid cache_key: should be a Proc" unless @options[:cache_key] && @options[:cache_key].is_a?(Proc)
         key = @options[:cache_key].call *@args
         result = cache.fetch key
         if result.nil?
           puts "Cache Miss #{@namespace.downcase}_#{@name.downcase}  #{key} \n"
           result = yield
           cache.store key, result
         else
           puts "Cache Hit #{@namespace.downcase}_#{@name.downcase}  #{key} \n"
         end
      else
         puts "Cache Skip #{@namespace.downcase}_#{@name.downcase} \n"
         result = yield
      end
      result            
    end
  end
end
