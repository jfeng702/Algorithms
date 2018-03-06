# Implement a queue with #enqueue and #dequeue, as well as a #max API,
# a method which returns the maximum element still in the queue. This
# is trivial to do by spending O(n) time upon dequeuing.
# Can you do it in O(1) amortized? Maybe use an auxiliary storage structure?

# Use your RingBuffer to achieve optimal shifts! Write any additional
# methods you need.

require_relative 'ring_buffer'

class QueueWithMax
  attr_accessor :store, :max_store

  def initialize
    @store = RingBuffer.new
    @max_store = RingBuffer.new
  end

  def enqueue(val)
    @store.unshift(val)
    if @max_store.length == 0 || @max_store[@max_store.length - 1] < val
      @max_store = [val]
    else
      @max_store.push(val)
    end
  end

  def dequeue

    popped = @store.pop
    if @max_store[0] == popped
      @max_store.shift
    end

  end

  def max
    @max_store[0]
  end

  def length
    @store.length
  end

end
