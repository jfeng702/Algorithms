require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @start_idx = 0
    @capacity = 8
    @length = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[(@start_idx + index) % @capacity]
  end

  # O(1)
  def []=(index, val)
    check_index(index)
    @store[(@start_idx + index) % @capacity] = val
  end

  # O(1)
  def pop
    tmp = self[length-1]
    self[length-1] = nil
    self.length -= 1
    tmp
  end

  # O(1) ammortized
  def push(val)
    p @store
    resize! if @length == @capacity
    @store[(@start_idx+length) % @capacity] = val
    self.length += 1
    # p @length
  end

  # O(1)
  def shift
    p @store
    # p "start idx is #{@start_idx}"
    shifted = self[0]
    # p "#{self[0]}"
    self[0] = nil
    @start_idx += 1
    self.length -= 1


    # p "length is #{length}"
    return shifted

  end

  # O(1) ammortized
  def unshift(val)
    resize! if @length == @capacity
    # p length
    @start_idx = (@start_idx-1) % @capacity
    @store[@start_idx] = val
    # p @store
    # p @length
    self.length += 1
  end


  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    unless (index >= 0) && (index < length)
      raise 'index out of bounds'
    end
  end

  def resize!

    new_capacity = @capacity * 2
    new_store = StaticArray.new(new_capacity)
    (0..@length - 1).each do |i|
      new_store[i] = self[i]
    end
    @capacity = new_capacity
    @start_idx = 0
    @store = new_store
  end
end
