require 'memcache'


module UrlQueue
  class UrlQueue
    def initialize(name = 'url_queue')
      @name = name 
      @starling = MemCache.new('127.0.0.1:22122', :multithread => true)
    end
    
    def add(url)
      @starling.set('url_queue', url)
    end
    
    def get
      @starling.get('url_queue')
    end
  end
end
