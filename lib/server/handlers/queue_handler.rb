module Server
  module Handlers
  
    class QueueHandler < Handler
    
      def initialize(name, namespace, options)
        super name, namespace, options
        @queue = UrlQueue::UrlQueue.new        
      end
    
      #TODO
      # 
      # If 'force' is not specified add to queue and set status to '202 - Processing' and return
      # If 'force' is specified yield to api function
      # Also need to modify CacheHandler to not save after yield unless force
      # And modify JsonHandler to use data envelope 
      def action(request, response, &block)
        if request.force?
          puts "QueueHandler: Forced request - yielding \n"
          yield request, response
        else
          response.status = 202
          response.message = "Processing.  Please retry your request shortly"
          @queue.add request.url({:force => true })
        end
      end
    
    end
  end
end  
    
