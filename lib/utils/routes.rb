
module NowPlaying
  module Utils
    module Routes
        def np_namespace(name)
         yield NPNamespace.new(name)
        end
        
        class NPNamespace
        
          def initialize(name)
            @namespace = name 
          end        
          
          def route(name, arg_names, options={}, &block)
            options = { :cache => true, 
                        :cache_key => Proc.new { |*args| args.join("-") } 
                      }.merge options
            namespace = @namespace
            ns = self            
            get "/#{namespace}/#{name}.js" do
              args = arg_names.map { |a| params[a] }
              result = nil
              if options[:cache]
                 raise "Invalid cache_key: should be a Proc" unless options[:cache_key] && options[:cache_key].is_a?(Proc)
                 key = options[:cache_key].call *args
                 result = ns.cache name, key do
                   json_p block.call *args
                 end
              else
                result = json_p block.call *args
              end
              result
            end    
          end
          
          def cache(name, key, &block)
            cache = ::Utils::Cache.new "#{@namespace}/#{name}"
            result = cache.fetch key
            if result.nil?
              result = yield
              cache.store key, result
            end
            result            
          end
        end
    end
  end
end
