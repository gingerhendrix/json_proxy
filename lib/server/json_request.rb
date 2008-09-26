module Server
  class JsonRequest < Rack::Request
     attr_accessor :args
     
     alias_method :orig_params, :params
     def params
       @indifferent_params ||= HashWithIndifferentAccess.new orig_params
     end
     
     def force?
      !self['force'].nil?
    end

  end
end
