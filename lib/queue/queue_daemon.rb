
module UrlQueue
  class QueueDaemon
    def initialize
      @q = UrlQueue.new
    end
    
    def process
      while url = @q.get
        fetch url
      end
    end
    
    private
    
    def fetch(url)
      Net::HTTP.get_response(URI.parse(url))
    end
    
  end
end


