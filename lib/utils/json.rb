
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
    "[" + (map { |value| value.to_json } * ', ') + "]"
  end
  
end

class Exception

  def to_json(*a)
    { :name => self.class.name,
      :message => self.message,
      :backtrace => self.backtrace}.to_json
  end

end
