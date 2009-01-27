
class Object

  def to_json(*a)
    result = {
    }
    instance_variables.each do | name|
      result[name[1..-1]] = instance_variable_get name
    end
    result.to_json
  end

end

class Array


  def to_json(*a)
    "[#{map { |value| ActiveSupport::JSON.encode(value) } * ', '}]"
  end
  
end

class Exception

  def to_json(*a)
    "{ \"exception\" : \"#{self.to_s}\"}"
  end

end
