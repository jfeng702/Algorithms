class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    each_with_index.inject(0) do |intermediate_hash, (el, i)|
      (el.hash + i.hash) ^ intermediate_hash
    end
  end
end

class String
  def hash
    result = 0
    i = 0
    while i < self.length
      result += self[i].ord * i
      i += 1
    end
    result
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    result = 0
    self.values.each do |val|
      if val.is_a?(Integer)
        result += val
      else
        result += val.ord
      end
    end
    result
  end
end
