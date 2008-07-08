module Utils
  class CouchCache
    def initialize(prefix)
      @server = CouchServer.new "localhost", "5984"
      @database = prefix
      if @server.get("/#{@database}").code == "404"
        @server.put("/#{@database}", "")
      end
    end
    
    def store(key, value)
      @server.put("/#{@database}/#{key.gsub(/[^a-zA-Z0-9_]/, "_")}", value)
    end
    
    def fetch(key)
      res = @server.get("/#{@database}/#{key.gsub(/[^a-zA-Z0-9_]/, "_")}")
      res.code == "200" ? res.body : nil
    end
  end
end
