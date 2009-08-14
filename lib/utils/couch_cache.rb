module Utils
  class CouchCache
    def initialize(prefix)
      @db = CouchRest.database!("http://#{configatron.couchdb.server}:#{configatron.couchdb.port}/#{prefix}");
    end
    
    def store(key, response)
      cacheObj = Hash.new      
      cacheObj['mtime'] = Time.new.to_i
      cacheObj['ctime'] = Time.new.to_i
      cacheObj['app_version'] = JsonProxy::APP_VERSION
      cacheObj['_id'] = sanitize(key)
      cacheObj['errors'] = response.errors
      cacheObj['data'] = response.body
      cacheObj['partial'] = response.partial?
      
      @db.save_doc(cacheObj)
    end
    
    def update(cached, response)
      cacheObj = Hash.new      
      cacheObj['ctime'] = cached['ctime']
      cacheObj['mtime'] = Time.new.to_i
      cacheObj['_rev'] = cached['_rev']
      cacheObj['_id'] = cached['_id']
      cacheObj['app_version'] = JsonProxy::APP_VERSION
      cacheObj['errors'] = response.errors
      cacheObj['data'] = response.body
      cacheObj['partial'] = response.partial?
      
      @db.save_doc(cacheObj)
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
