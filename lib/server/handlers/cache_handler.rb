module Server
  module Handlers
    class CacheHandler < Handler
      def action(request, response)
        if @options[:cache]
          cache = ::Utils::CouchCache.new "#{@namespace.downcase}_#{@name.downcase}"
          raise "Invalid cache_key: should be a Proc" unless @options[:cache_key] && @options[:cache_key].is_a?(Proc)
          key = @options[:cache_key].call request.args
          result = cache.fetch key
          if result.nil?
            puts "Cache Miss #{@namespace.downcase}_#{@name.downcase}  #{key} \n"
            result = yield request, response
            cache.store key, result
          else
            puts "Cache Hit #{@namespace.downcase}_#{@name.downcase}  #{key} \n"
          end
        else
          puts "Cache Skip #{@namespace.downcase}_#{@name.downcase} \n"
          result = yield request, response
        end
        response.body = result
      end
    end
  end
end
