require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @store = StaticArray.new(0)
    @length = 0
    @capacity = 8
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    check_index(index)
    @store[index] = value
  end

  # O(1)
  def pop
    raise 'index out of bounds' if length == 0
    @store[length - 1] = nil
    @length -= 1
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @length == @capacity
    @length += 1
    @store[length] = val
  end

  # O(n): has to shift over all the elements.
  def shift
    raise 'index out of bounds' if length == 0
    i = 1
    new_store = []
    while i < length
      new_store << @store[i]
      i += 1
    end
    @store = new_store
    self.length -= 1
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    new_store = [val]
    i = 0
    while i < length
      new_store << @store[i]
      i += 1
    end
    @store = new_store
    self.length += 1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    if index > length - 1
      raise 'index out of bounds'
    end
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!

    @capacity *= 2
  end
end
