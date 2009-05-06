require 'pp'

module Server
  module Handlers
    
    class ExceptionHandler < Handler
       def initialize(*args)
        @log = Logging.logger[self]
        super(*args)
       end
    
       def action(request, response, &block)
         begin
           yield request, response
         rescue Exception => e
           @log.error "Exception: #{e}"
           response.errors.push :error => "Error: #{e}"
         end
       end
    end
  end
end
