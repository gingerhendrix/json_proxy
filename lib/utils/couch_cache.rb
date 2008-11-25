module Utils
  class CouchCache
    def initialize(prefix)
      @server = CouchServer.new configatron.couchdb.server, configatron.couchdb.port
      @database = prefix
      if @server.get("/#{@database}").code == "404"
        @server.put("/#{@database}", "")
      end
    end
    
    def store(key, value)
      @server.put uri_for(key), value
    end
    
    def fetch(key)
      res = @server.get uri_for(key)
      res.code == "200" ? res.body : nil
    end
    
    def delete(key)
      @server.delete uri_for(key)
    end
    
    private
    
    def uri_for(key)
      "/#{@database}/#{key.gsub(/[^a-zA-Z0-9_]/, "_")}"
    end
  end
end
