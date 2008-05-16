
module NowPlaying
  module Utils
    module Routes
        def np_namespace(name)
         yield NPNamespace.new(name)
        end
        
        class NPRoute

          def params
            @params          
          end
                              
          def initialize(namespace, name, arg_names, options={}, block = Proc.new)
            @options = default_options.merge options
            @block = block
            @arg_names = arg_names
            @name = name
            @namespace = namespace
            route = self            
            get "/#{namespace}/#{name}.js" do
              route.action(params)
            end          
          end
          
          def action(params)
            @params = params
            @args = @arg_names.map { |a| params[a] }
            result = nil
            result = cache do
               json @block.call *@args
            end 
            json_padding result          
          end
          
          def default_options
            { :cache => true, 
              :cache_key => Proc.new { |*args| args.join("-") } 
            }
          end
          
          def json(response)
            response.to_json
          end
          
          def json_padding(response)
            response_text = (response.is_a?(String) ? response : response.to_json)
            if params[:jsonp]
              out = params[:jsonp] + "(" + response_text + ")"
            else
              out = "(" + response_text + ")"
            end
            out
         end
          
          def cache(&block)
            cache = ::Utils::Cache.new "#{@namespace}/#{@name}"
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
        
        class NPNamespace
        
          def initialize(name)
            @namespace = name 
          end        
                    
          def route(name, arg_names, options={}, &block)
            NPRoute.new @namespace, name, arg_names, options, &block
          end
          
    end
  end
end
