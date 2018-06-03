class QuickSort
  # Quick sort has average case time complexity O(nlogn), but worst
  # case O(n**2).

  # Not in-place. Uses O(n) memory.
  def self.sort1(array)
    pivot = array.first
    return array if array.length < 2
    lower = array.drop(1).select { |el| el <= pivot }
    higher = array.drop(1).select { |el| el > pivot }
    QuickSort.sort1(lower) + [pivot] + QuickSort.sort1(higher)
  end

  # In-place.
  def self.sort2!(array, start = 0, length = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }
    return array if length < 2
    pivot_idx = QuickSort.partition(array, start, length, &prc)
    QuickSort.sort2!(array, start, pivot_idx - start, &prc)
    QuickSort.sort2!(array, pivot_idx + 1, length - pivot_idx - 1 - start, &prc)
    array
  end

  def self.partition(array, start, length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    pivot = array[start]
    current = start + 1
    partition_idx = start + 1
    while current < start + length
      if array[current] < pivot
        array[current], array[partition_idx] = array[partition_idx], array[current]
        partition_idx += 1
      end
      current += 1
    end
    array[partition_idx - 1], array[start] = array[start], array[partition_idx - 1]

    # pivot_idx
    pivot_idx = partition_idx - 1
  end

end
