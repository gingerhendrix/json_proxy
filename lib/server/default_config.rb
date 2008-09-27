
configatron do |config|
    config.namespace(:json) do |json|
        json.envelope = false
        json.dataField = 'data'
        json.responseCode = 'status'
        json.responseMessage = 'statusText'
    end


    config.namespace(:couchdb) do |couchdb|
        couchdb.server = "localhost"
        couchdb.port = "5984"
    end
end
