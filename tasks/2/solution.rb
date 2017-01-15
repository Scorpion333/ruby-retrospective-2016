class Hash
  def fetch_deep(path)
    keys = path.split('.')
    current = self
    
    keys.each do |key|
      return nil if current.nil?
      current = current[key.to_i] || current[key] || current[key.to_sym]
    end
    current
  end
  
  def reshape(shape)
    shape.map do |key, value|
      new_value = value.is_a?(String) ? fetch_deep(value) : reshape(value)
      [key, new_value]
    end.to_h
  end
end

class Array
  def reshape(shape)
    map { |element| element.reshape(shape) }
  end
end