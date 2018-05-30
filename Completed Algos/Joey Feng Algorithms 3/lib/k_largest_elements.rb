require_relative 'heap'

def k_largest_elements(array, k)
  sorted_arr = array.heap_sort!
  sorted_arr[-k..-1]
end
