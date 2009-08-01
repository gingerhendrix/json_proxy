module Server
  class JsonResponse < Rack::Response
    attr_accessor :message
    attr_accessor :errors
    
    def initialize
      super
      @errors = []
    end
    
    def partial?
      !!@partial
    end
    
    def partial!
      @partial = true
    end
    
    def to_json
      { :status => self.status, 
        :statusMessage => self.message,
        :errors => self.errors,
        :data => self.body }.to_json
    end
  end 
end
