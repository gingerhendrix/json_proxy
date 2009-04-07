
module Server
  module Handlers
    
    class JsonHandler < Handler

      def after_action(request, response)
        response_text = response.to_json                            
        if request.params['jsonp']
          #puts "#{@namespace}/#{@name} #{@args} jsonp: #{@params['jsonp']} \n"
          response.body = request.params['jsonp'] + "(" + response_text + ")"
        else
          response.body = response_text;
        end
        response["Content-Length"] = response.body.length.to_s
      end 
    
    end
  end
end
