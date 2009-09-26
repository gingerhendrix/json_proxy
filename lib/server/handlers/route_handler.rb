
module Server
  module Handlers
    class RouteHandler < Handler
      def initialize(name, namespace, options, block)
         @block = block
         super(name, namespace, options)
      end
      
      def get(service, params={})
        paramString = ""
        sep = "?"
        params.each do |key, value|
          paramString += "#{sep}#{key}=#{value}"
          sep = "&"
        end
        uri = URI.parse("http://#{@request.host}:#{@request.port}/#{@namespace}/#{service}.js"+paramString)
        Net::HTTP.get_response(uri)
      end
      
      def database(namespace, name)
               CouchRest.database!("http://#{configatron.couchdb.server}:#{configatron.couchdb.port}/#{namespace}_#{name}");
      end
      
      def action(request, response)
        @request = request
        @response = response
 
        # Some serious metaclass hackery 
        # Aim is to execute block in context of this object, and with the specified arguments
        # Can't do both with proc.call or instance_eval 
        # Can't work out if this modifies self's class (i.e. RouteHandler or self's virtual class)
        
        self.class.send(:define_method, :route, @block)
        begin
          response.body = route *request.args
        rescue 
          response.status = 500
          response.errors << $!
        end
      end
    
    end
  
  end
end
