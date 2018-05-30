# This class just dumbs down a regular Array to be statically sized.
class StaticArray
  def initialize(length)
    @store = Array.new(length)
    @length = length
  end

  # O(1)
  def [](index)
    if index + 1 > @length
      raise "index out of bounds"
    end
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
  end


  attr_accessor :store
end
