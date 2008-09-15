module Server
  module Handlers
    
    class ArgumentValidationHandler < Handler
    
      def before_action(request, response)
        params = HashWithIndifferentAccess.new request.params
        arg_names = @options[:arg_names]
        missing = arg_names.select { |a| params[a.to_s].nil? || params[a.to_s]=="" }
        if(missing.length > 0)
          raise "Missing arguments #{missing}"         
        end

        class << request
          attr_accessor :args
        end

        request.args = arg_names.map { |a| params[a.to_s] }
      end
      
    end
    
  end
end
