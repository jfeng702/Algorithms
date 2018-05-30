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
    chars = self.split('')
    sum = 0
    chars.each_with_index do |el, idx|
      sum += el.ord * idx
    end
    sum
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    self.keys.length
  end
end
