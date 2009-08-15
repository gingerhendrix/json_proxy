module Server
  module Handlers
    class CacheHandler < Handler
    
      def action(request, response, &block)
        @cache = ::Utils::CouchCache.new "#{@namespace.downcase}_#{@name.downcase}"
        raise "Invalid cache_key: should be a Proc" unless @options[:cache_key] && @options[:cache_key].is_a?(Proc)
        @key = @options[:cache_key].call(*request.args)

        begin
          result = @cache.fetch @key
          
          request.cached_response = result
          response.body = result['data']  
          
          if result['partial'] || expired?(result)
            yield request, response
            @cache.update(result, response) if request.force?   
          elsif(result['errors'] && result['errors'].length > 0)
            response.errors.concat result['errors']
            response.status = 500
          end
        rescue RestClient::ResourceNotFound => e
           #puts "Cache miss!"
           yield request, response
           @cache.store(@key, response) if request.force?
        end
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
