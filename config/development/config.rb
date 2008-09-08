
configatron do |config|
    config.namespace(:couchdb) do |couchdb|
        couchdb.server = "localhost"
        couchdb.port = "5984"
      end
end

