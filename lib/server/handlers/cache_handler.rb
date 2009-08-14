module Server
  module Handlers
    class CacheHandler < Handler
    
      def action(request, response, &block)
        @cache = ::Utils::CouchCache.new "#{@namespace.downcase}_#{@name.downcase}"
        raise "Invalid cache_key: should be a Proc" unless @options[:cache_key] && @options[:cache_key].is_a?(Proc)
        @key = @options[:cache_key].call(*request.args)

        begin
          #puts "Fetching #{@key}\n"
          result = @cache.fetch @key
          #puts "Result: " + result.inspect + "\n"
          if result['partial']
            response.body = result['data']  
            yield request, response
            update_cache(result, response) if request.force?   
          elsif expired?(result)
            yield request, response
            update_cache(result, response) if request.force?   
          else
            response.body = result['data']  
            if(result['errors'] && result['errors'].length > 0)
              response.errors.concat result['errors']
              response.status = 500
            end
          end
          
        rescue RestClient::ResourceNotFound => e
           #puts "Cache miss!"
           yield request, response
           add_to_cache response if request.force?
        end
        
      end
      
      def update_cache(result, response)
        cacheObj = Hash.new      
        cacheObj['ctime'] = result['ctime']
        cacheObj['mtime'] = Time.new.to_i
        cacheObj['_rev'] = result['_rev']
        cacheObj['_id'] = result['_id']
        cacheObj['app_version'] = JsonProxy::APP_VERSION
        cacheObj['errors'] = response.errors
        cacheObj['data'] = response.body
        cacheObj['partial'] = response.partial?
        #puts "Forced query - Storing result #{cacheObj.to_json}\n"
        @cache.store @key, cacheObj
      end
      
      def add_to_cache(response)
        cacheObj = Hash.new      
        cacheObj['mtime'] = Time.new.to_i
        cacheObj['ctime'] = Time.new.to_i
        cacheObj['app_version'] = JsonProxy::APP_VERSION
        cacheObj['errors'] = response.errors
        cacheObj['data'] = response.body
        cacheObj['partial'] = response.partial?
        #puts "Forced query - Storing result #{cacheObj.to_json}\n"
        @cache.store @key, cacheObj
      end
      
      def remove_from_cache(key)
      
      end
      
      def expired?(result)
         if result['mtime'].nil?
          return true
         elsif (result['mtime'].to_i + @options[:cache_expiry] ) < Time.new.to_i
          return true
         elsif result['app_version'].nil?
          return true
         elsif result['app_version'] < JsonProxy::APP_VERSION
          return true
         else
          return false
         end
      end
      
    end
  end
end
