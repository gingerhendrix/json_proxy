module Server
  module Handlers
    
    class ExceptionHandler < Handler
       def action(request, response)
         begin
           yield request, response
         rescue Exception => e
           puts "Exception: #{e} \n"
           pp e.backtrace 
           puts "\n"
           response.body = {:error => "Error: " + e }
         end
       end
    end
  end
end
