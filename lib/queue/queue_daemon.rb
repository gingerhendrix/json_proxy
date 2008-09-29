
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
    
    private
    
    def fetch(url)
      Net::HTTP.get_response(URI.parse(url))
    end
    
  end
end


