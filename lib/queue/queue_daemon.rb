
module UrlQueue
  class QueueDaemon
    def initialize
      @q = UrlQueue.new
    end
    
    def process
      @processed = 0
      while url = @q.get
        puts "Fetching #{url} \n"
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
          puts "Queue empty \n"
        elsif processed > 0
          puts "Processed #{processed}\n"
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


