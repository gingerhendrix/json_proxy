module Discogs
  class SimpleRelease 
   attr_accessor :discog_id, 
                  :title, 
                  :label, 
                  :format, 
                  :year,
                  :discog_status,
                  :discog_type,
                  :trackinfo
                  
    def initialize(discog_id, attrs)
      @discog_id = discog_id
      attrs.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end                    
  
  end
end
