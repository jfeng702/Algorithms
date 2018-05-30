require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @length = 0
    StaticArray.new(@length)
    @store = []
    @capacity = 8
  end

  # O(1)
  def [](index)
    if index + 1 > self.length
      raise "index out of bounds"
    end
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
  end

  # O(1)
  def pop
    raise 'index out of bounds' if self.length == 0
    @store.pop
    @length -= 1
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @length == @capacity
    @store.push(val)
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    raise 'index out of bounds' if self.length == 0
    @store = @store.drop(1)
    @length -= 1
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    @store = [val] + @store
    @length += 1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise 'index out of bounds' if index + 1> @length
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2
  end
end
