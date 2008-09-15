module Server
  module Handlers
    class Handler
      def initialize(namespace, name, options = {})
        @namespace = namespace
        @name = name
        @options = options
      end
    
      def action(request, response, &block)
         before_action request, response
         yield request, response
         after_action request, response
      end 
      
      def before_action(request, response)
      end
      
      def after_action(request, response)
      end
      
    end
  end
end
