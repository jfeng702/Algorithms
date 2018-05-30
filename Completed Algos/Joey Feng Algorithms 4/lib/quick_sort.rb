class QuickSort
  # Quick sort has average case time complexity O(nlogn), but worst
  # case O(n**2).

  # Not in-place. Uses O(n) memory.
  def self.sort1(array)
    return array if array.length <= 1
    pivot = array.first
    left = []
    right = []
    array.drop(1).each do |el|
      if el < pivot
        left.push(el)
      else
        right.push(el)
      end
    end
    quicksort(left) + [pivot] + quicksort(right)
  end

  # In-place.
  def self.sort2!(array, start = 0, length = array.length, &prc)
    return array if length < 2
    prc ||= Proc.new{|x,y| x <=> y}
    pivot_idx = QuickSort.partition(array, start, length, &prc)
    left_length = pivot_idx - start
    right_length = length - pivot_idx - 1
    QuickSort.sort2!(array, start, left_length, &prc)
    QuickSort.sort2!(array, pivot_idx+1, right_length, &prc)
    array
  end

  def self.partition(array, start, length, &prc)
    prc ||= Proc.new{|x,y| x <=> y}
    pivot = start
    partition = pivot
    idx = partition
    until idx == start + length
      p "array is #{array}"
      p "partition is #{partition}"
      p "array[idx] is #{array[idx]}"
      p "array[pivot] is #{array[pivot]}"
      if prc.call(array[idx], array[pivot]) == -1
        partition += 1
        array[idx], array[partition] = array[partition], array[idx]

      end
      idx += 1
    end
    array[pivot], array[partition] = array[partition], array[pivot]
    p array
    partition
  end
end
