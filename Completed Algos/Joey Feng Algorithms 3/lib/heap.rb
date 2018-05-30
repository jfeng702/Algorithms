class BinaryMinHeap
  attr_reader :store, :prc

  def initialize(&prc)
    @store = []

  end

  def count
    @store.length
  end

  def extract
    @store[0], @store[-1] = @store[-1], @store[0]
    extracted = @store.pop
    BinaryMinHeap.heapify_down(@store, 0)
    extracted
  end

  def peek
    @store.first
  end

#  O(amount of levels)
  def push(val)
    @store.push(val)
    BinaryMinHeap.heapify_up(@store, @store.length - 1, &@prc)
  end

  public
  def self.child_indices(len, parent_index)
    indices = []
    child_idx1 = parent_index * 2 + 1
    child_idx2 = parent_index * 2 + 2
    if len > child_idx1
      indices.push(child_idx1)
    end
    if len > child_idx2
      indices.push(child_idx2)
    end
    indices
  end

  def self.parent_index(child_index)
    raise 'root has no parent' if child_index == 0
    parent_idx = (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)

    prc ||= Proc.new {|el1, el2| el1 <=> el2}
    child_indices = BinaryMinHeap.child_indices(len, parent_idx)
    child_id = nil
    if child_indices.length < 2
      child_id = child_indices[0]
    else
      child_id = (prc.call(array[child_indices[0]], array[child_indices[1]]) == -1 ? child_indices[0] : child_indices[1])
    end
    # p child_indices
    #   p array
    #   p prc.call(array[parent_idx], array[child_id])
      # p "Parent  is #{array[parent_idx]}"
      # p "child is #{array[child_id]}"
      p "Parent idx  is #{parent_idx}"
      p "child idx is #{child_id}"
      # p array[child_id]

    while child_id && prc.call(array[parent_idx], array[child_id]) > 0
      # p "Array is #{array}"
      array[parent_idx], array[child_id] = array[child_id], array[parent_idx]
      # swapped child id is now parent id (traversing down)
      parent_idx = child_id
      child_indices = BinaryMinHeap.child_indices(len, parent_idx)
      child_id = nil
      if child_indices.length < 2
        child_id = child_indices[0]
      else
        child_id = (prc.call(array[child_indices[0]], array[child_indices[1]]) == -1 ? child_indices[0] : child_indices[1])
      end
      break unless child_id
      # p "Child ID #{child_id}"
      # p "Parent ID #{parent_idx}"
      # p "Proc evaluates to #{prc.call(array[parent_idx], array[child_id])}"
    end
    array
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    return array if child_idx == 0
    prc ||= Proc.new {|x,y| x <=> y }
    parent_idx = BinaryMinHeap.parent_index(child_idx)
    while prc.call(array[parent_idx],array[child_idx]) == 1
      # swap
      array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]
      child_idx = parent_idx
      break if child_idx == 0
      parent_idx = BinaryMinHeap.parent_index(child_idx)
    end
    array
  end
end
