
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
