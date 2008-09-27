module Server
  module Handlers
    class CacheHandler < Handler
      def action(request, response, &block)
        if @options[:cache]
          cache = ::Utils::CouchCache.new "#{@namespace.downcase}_#{@name.downcase}"
          raise "Invalid cache_key: should be a Proc" unless @options[:cache_key] && @options[:cache_key].is_a?(Proc)
          key = @options[:cache_key].call request.args
          result = cache.fetch key
          if result.nil?
            puts "Cache Miss #{@namespace.downcase}_#{@name.downcase}  #{key} \n"
            yield request, response
            if request.force?
              puts "Forced query - Storing result #{response.body}\n"
              cache.store key, response.body.to_json
            end
          else
            puts "Cache Hit #{@namespace.downcase}_#{@name.downcase}  #{key} \n"
            response.body = result
          end
        else
          puts "Cache Skip #{@namespace.downcase}_#{@name.downcase} \n"
          result = yield request, response
          response.body = result
        end
      end
    end
  end
end
