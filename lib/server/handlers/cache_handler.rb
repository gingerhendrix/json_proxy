module Server
  module Handlers
    class CacheHandler < Handler
    
      def action(request, response, &block)
        @cache = ::Utils::CouchCache.new "#{@namespace.downcase}_#{@name.downcase}"
        raise "Invalid cache_key: should be a Proc" unless @options[:cache_key] && @options[:cache_key].is_a?(Proc)
        @key = @options[:cache_key].call(*request.args)

        result = @cache.fetch @key

        if result.nil? 
          yield request, response
          add_to_cache response if request.force?
        else
          result =  JSON.parse result

          if expired?(result)
            yield request, response

            if request.force?      
              update_cache(result, response)
            end
          else
            response.body = result['data']  
          end
        end
      end
      
      def update_cache(result, response)
        cacheObj = Hash.new      
        cacheObj['ctime'] = result['ctime']
        cacheObj['mtime'] = Time.new.to_i
        cacheObj['_rev'] = result['_rev']
        cacheObj['_id'] = result['_id']
        cacheObj['app_version'] = JsonProxy::APP_VERSION
        cacheObj['data'] = response.body
        #puts "Forced query - Storing result #{cacheObj.to_json}\n"
        @cache.store @key, cacheObj.to_json
      end
      
      def add_to_cache(response)
        cacheObj = Hash.new      
        cacheObj['mtime'] = Time.new.to_i
        cacheObj['ctime'] = Time.new.to_i
        cacheObj['app_version'] = JsonProxy::APP_VERSION
        cacheObj['data'] = response.body
        #puts "Forced query - Storing result #{cacheObj.to_json}\n"
        @cache.store @key, cacheObj.to_json      
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
