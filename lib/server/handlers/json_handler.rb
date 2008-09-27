
module Server
  module Handlers
    
    class JsonHandler < Handler

      def after_action(request, response)
        if(!configatron.json.envelope)
          response_text = (response.body.is_a? String) ? response.body : response.body.to_json 
        else
          #response_text = configatron.json
        end  
        if request.params['jsonp']
          #puts "#{@namespace}/#{@name} #{@args} jsonp: #{@params['jsonp']} \n"
          response.body = request.params['jsonp'] + "(" + response_text + ")"
        else
          response.body = response_text;
        end
      end 
    
    end
  end
end
