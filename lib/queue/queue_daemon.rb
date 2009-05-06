
module UrlQueue
  class QueueDaemon
    def initialize
      @q = UrlQueue.new
      @log = Logging.logger[self]
    end
    
    def process
      @processed = 0
      while url = @q.get
        @log.info "Fetching #{url} \n"
        fetch url
        @processed += 1
      end
      @processed
    end
    
    def do_loop
      sleeping = false
      loop do
        processed = process
        if processed == 0 && !sleeping
          sleeping = true
          @log.info "Queue empty \n"
        elsif processed > 0
          @log.info "Processed #{processed}\n"
          sleeping = false
        end
        sleep(1)
      end
    end
    
    private
    
    def fetch(url)
      Net::HTTP.get_response(URI.parse(url))
    end
    
  end
end


