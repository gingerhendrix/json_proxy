module Utils
  class CouchCache
    def initialize(prefix)
      @db = CouchRest.database!("http://#{configatron.couchdb.server}:#{configatron.couchdb.port}/#{prefix}");
    end
    
    def store(key, value)
      value['_id'] = sanitize(key)
      @db.save_doc(value)
    end
    
    def fetch(key)
      @db.get(sanitize(key))
    end
    
    def delete(key)
      @db.delete_doc sanitize(key)
    end
    
    private 
    
    def sanitize(key)
      key.gsub(/[^a-zA-Z0-9_]/, "_")
    end
    
  end
end
