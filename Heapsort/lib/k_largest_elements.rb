require_relative 'heap'

def k_largest_elements(array, k)
  result = BinaryMinHeap.new
  until array.empty?
    result.push(array.pop)
  end

  (result.count-k).times do
    result.extract
  end
  result.store
end
