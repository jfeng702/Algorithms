class BinaryMinHeap
  attr_reader :store, :prc

  def initialize(&prc)
    @store = []
  end

  def count
    @store.length
  end

  def extract
    @store[0], @store[@store.length - 1] = @store[@store.length - 1], @store[0]
    extracted = @store.pop
    BinaryMinHeap.heapify_down(@store, 0, @store.length, &prc)
    extracted
  end

  def peek
    @store.first
  end

# n log n time complexity (number of levels in heap)
  def push(val)
    @store.push(val)
    BinaryMinHeap.heapify_up(@store, @store.length - 1, @store.length, &prc)
  end

  public
  def self.child_indices(len, parent_index)
    arr = []
    child_one = parent_index * 2 + 1
    child_two = parent_index * 2 + 2
    arr.push(child_one) if child_one < len
    arr.push(child_two) if child_two < len
    arr
  end

  def self.parent_index(child_index)
    raise 'root has no parent' if child_index < 1
    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new{|el1, el2| el1 <=> el2 }
    child_indices = self.child_indices(len, parent_idx)
    if child_indices.all? {|child_idx| prc.call(array[parent_idx], array[child_idx]) < 0}
      return array
    end

    if child_indices.length == 2
      swap_idx = prc.call(array[child_indices[0]], array[child_indices[1]]) < 0 ? child_indices[0] : child_indices[1]
    else
      swap_idx = child_indices[0]
    end
    array[parent_idx], array[swap_idx] = array[swap_idx], array[parent_idx]
    self.heapify_down(array, swap_idx, len, &prc)

  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new {|el1, el2| el1 <=> el2 }
    return array if child_idx == 0
    parent_idx = self.parent_index(child_idx)
    if prc.call(array[parent_idx], array[child_idx]) < 0
      return array
    end

    swap_idx = parent_idx
    array[child_idx], array[swap_idx] = array[swap_idx], array[child_idx]
    self.heapify_up(array, parent_idx, len, &prc)
  end
end
