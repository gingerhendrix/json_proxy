
configatron do |config|
    config.namespace(:couchdb) do |couchdb|
        couchdb.server = "linode.gandrew.com"
        couchdb.port = "5984"
      end
end

