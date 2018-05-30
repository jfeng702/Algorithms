## Heaps and Heapsort

---
## Class Methods
* Methods that will let us perform heap operations on any array, allowing us to build heaps with regular arrays and subarrays, if we so choose (`#heapsort!`)

---
## Child Indices
* As detailed in the video, the formulas to calculate the child indices are  `2 * parent_index + 1`  and  `2 * parent_index + 2`, as long as they are within range
```ruby  
def self.child_indices(len, parent_index)
    [2 * parent_index + 1, 2 * parent_index + 2].select do |idx|
      # Only keep those in range.
      idx < len
    end
  end
```
---
## Parent Indices
* Using integer division, we can use one formula for both odd and even indexed children
```ruby

  def self.parent_index(child_index)
    # If child_index is odd: `child_index == 2 * parent_index + 1`
    # means `parent_index = (child_index - 1) / 2`.
    #
    # If child_index is even: `child_index == 2 * parent_index + 2`
    # means `parent_index = (child_index - 2) / 2`. Note that, because
    # of rounding, when child_index is even: `(child_index - 2) / 2 ==
    # (child_index - 1) / 2`.

    raise "root has no parent" if child_index == 0
    (child_index - 1) / 2
  end
  ```
---

## Heapify Up
* Goal is to heapify after putting a new element onto the end of our heap
* Compares the child to its parent using the `parent_index` helper method and the provided `prc`
* Returns the input array when the heap property is satisfied, otherwise swaps the child with the parent and recursively calls `heapify_up` using the parent_idx
* Can also be done iteratively by using a pointer to the parent and updating it each loop
* `O(log(n))` time complexity - typical of traversing all the levels of a tree

---
## Heapify Up

```ruby
  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    # As a convenience, return array
    return array if child_idx == 0

    parent_idx = parent_index(child_idx)
    child_val, parent_val = array[child_idx], array[parent_idx]
    if prc.call(child_val, parent_val) >= 0
      # Heap property valid!
      return array
    else
      array[child_idx], array[parent_idx] = parent_val, child_val
      heapify_up(array, parent_idx, len, &prc)
    end
  end
```
---
## Heapify Down

* Goal is to heapify down after swapping the root for the last element, which lets us pop the root in `O(1)` time without having to readjust every element (or use a Ring Buffer).
* Stores a value for the parent and the indices of its children, adds all existing children to an array
* Returns the modified heap if all children satisfy heap property
* Else, find the smaller (or larger, depending on `prc`) of the children and swap
* Recursively call `heapify_down` on the index we swapped into
* Can be done iteratively by maintaining a pointer to the index we swap into and updating our parent and child pointers each loop
* `O(log(n))` time complexity

---
## Heapify Down


```ruby
def self.heapify_down(array, parent_idx, len = array.length, &prc)
   prc ||= Proc.new { |el1, el2| el1 <=> el2 }

   l_child_idx, r_child_idx = child_indices(len, parent_idx)

   parent_val = array[parent_idx]

   children = []
   children << array[l_child_idx] if l_child_idx
   children << array[r_child_idx] if r_child_idx

   if children.all? { |child| prc.call(parent_val, child) <= 0 }
     # Leaf or both children_vals >= (<=) parent_val. As a convenience,
     # return the modified array.
     return array
   end

   # Choose smaller of two children.
   swap_idx = nil
   if children.length == 1
     swap_idx = l_child_idx
   else
     swap_idx =
       prc.call(children[0], children[1]) == -1 ? l_child_idx : r_child_idx
   end

   array[parent_idx], array[swap_idx] = array[swap_idx], parent_val
   heapify_down(array, swap_idx, len, &prc)
 end
 ```
---
## Instance Methods
* Methods that we can call on an actual BinaryMinHeap object that set a store, allow for push and shift while automatically performing the heapifying, and let us pass a custom `prc` that can change behavior from min to max

---


```ruby
  def initialize(&prc)
    self.store = []
    self.prc = prc || Proc.new { |el1, el2| el1 <=> el2 }
  end

  def count
    store.length
  end

  def extract
    raise "no element to extract" if count == 0

    val = store[0]

    if count > 1
      store[0] = store.pop
      self.class.heapify_down(store, 0, &prc)
    else
      # Last element left.
      store.pop
    end

    val
  end

  def peek
    raise "no element to peek" if count == 0
    store[0]
  end

  def push(val)
    store << val
    self.class.heapify_up(store, self.count - 1, &prc)
  end

  protected
  attr_accessor :prc, :store
```

---
## Heapsort
* Build a heap in place one element at a time from the left by using a pointer to control the size of the heap and heapifying that portion after moving the pointer each time
* Maintain a pointer to separate the sorted part to the right from the remaining heap to the left
* Build the sorted right part by extracting (swapping element[0] with the element at the pointer, moving the pointer, then heapifying down on the remaining heap)
* Depending on whether you use a Min- or a MaxHeap, reverse the resulting array

---
## Heapsort (with MinHeap)

```ruby
require_relative 'heap'

class Array
  def heap_sort!
    2.upto(count).each do |heap_sz|
      BinaryMinHeap.heapify_up(self, heap_sz - 1, heap_sz)
    end

    count.downto(2).each do |heap_sz|
      self[heap_sz - 1], self[0] = self[0], self[heap_sz - 1]
      BinaryMinHeap.heapify_down(self, 0, heap_sz - 1)
    end

    self.reverse!
  end
end
```

---
## Heapsort (alternate with MaxHeap proc)

```ruby
require_relative "heap"

class Array
  def heap_sort!
    prc = Proc.new do |el1, el2|
      -1 * (el1 <=> el2)
    end
    pointer = 0
    while pointer < self.length
      BinaryMinHeap.heapify_up(self, pointer, &prc)
      pointer += 1
    end
    pointer -= 1

    while pointer >= 0
      self[0], self[pointer] = self[pointer], self[0]
      pointer -= 1
      BinaryMinHeap.heapify_down(self, 0, pointer+1, &prc)
    end
    self
  end
end
```

---
## K-Largest Elements
* Why are heaps implicated in this problem?
* What are the benefits of implementing a heap?

---
* First, we want to build a min heap that is the size of the set we would like to return
* Then, by consistently ejecting the minimum element every time we push another element onto the heap, we can be sure that we are retaining the largest elements; we always have a complete set of the largest current elements, so we can be confident that the one we eject should not be part of the final set.
* `O(nlog(k))`

---
```ruby
require_relative 'heap'

def k_largest_elements(array, k)
  result = BinaryMinHeap.new
  k.times do
    result.push(array.pop)
  end
  until array.empty?
    result.push(array.pop)
    result.extract
  end
  result.store
end
```

---
## Practical problems workshop

 We will be working at your seats to work through two practical applications of Heaps in solving interview questions.

 * Make sure you are discussing why and how you will be using heaps, as this is the best way to learn how to recognize future situations where you should implement them
 * As in a real interview, you might have to abstract the problem and come up with your own test cases, or maybe ask clarifying questions
 * You can use the provided BinaryMinHeap class, or your own

---
## 500 files

You are given 500 files, each containing the stock trading data for a company. Within each file all the trades have timestamps. The timestamps appear in ascending order. Your job is to create one file of all data in ascending time order. Achieve the best Time and Space complexity that you can, and don't modify the inputs.

---
## 500 files

* What is the naive solution? Time complexity?
* What property of the inputs would we like to take advantage of?
* How can heaps help?

---
## 500 files

* Naive solution: concatenate all arrays and sort: `O(nlog(n))`
* All inputs are already sorted: this means that the next element we want to add to our output is always among the first elements of the inputs.
* MinHeap consisting of the first elements will let us always extract the minimum element in `log(k)` time, where k is the number of input files.
* Key sub-problem: How to keep track of which file the extracted element originated from so that we can push the next element from that file onto our heap

---
## 500 files

```ruby
require_relative "heap"

def five_hundred_files(arr_of_arrs)
  # We will need to store info about where the element came from,
  # so we need to pass a proc that will compare the first item (the value)
  # from an entry containing relevant information
  prc = Proc.new { |el1, el2| el1[0] <=> el2[0] }
  heap = BinaryMinHeap.new(&prc)
  result = []

  # Populate with first elements
  arr_of_arrs.length.times do |i|
    # Relevant info: [value, origin array number, origin index]
    heap.push([arr_of_arrs[i][0], i, 0])
  end

  # Extract the minimum element and use the meta-data to select the
  # next element to push onto the heap
  while  heap.count > 0
    min = heap.extract
    result << min[0]

    next_arr_i = min[1]
    next_idx = min[2] + 1
    next_el = arr_of_arrs[next_arr_i][next_idx]

    heap.push([next_el, next_arr_i, next_idx]) if next_el
  end
  result
end


arr_of_arrs = [[3,5,7], [0,6], [0,6,28]]

p five_hundred_files(arr_of_arrs)
```

---

## Almost sorted

Timestamped data may not always make it into the database in the perfect order. Server loads, network routes, etc. Your job is to take in a very long sequence of numbers in real-time and efficiently print it out in the correct order. Each number is, at most, `k` away from its final sorted position. Target time complexity is `O(nlogk)` and target space is `O(k)`.

---
## Almost sorted
* Naive solution? Time complexity?
* How can we rephrase the defining property of the input stream that might give us insight into how to build our output?
* Why are heaps implicated?

---
## Almost sorted
* If the stream ends, we could store it and sort it: `O(nlogn)`. If the stream is truly unending, this would not work.
* We can rephrase the property as: "the correct output element will always be found within k steps from the index we are trying to populate".
* This implies that we could store the most recent `k` element and find the minimum: `O(nk)`
* Since we know we want the minimum from this stored set, that implies MinHeap and we can achieve `O(nlogk)`

---
## Almost sorted
```ruby
require_relative 'heap'

def almost_sorted(arr, k)
  heap = BinaryMinHeap.new
  # If k = 2, the first output element must be
  # within the first 3 numbers, so we build a heap of 3
  (k + 1).times do
    heap.push(arr.shift)
  end

  # Accounts for when the array runs out but we still have
  # numbers in our heap
  while heap.count > 0
    print heap.extract
    heap.push(arr.shift) if arr[0]
  end
end

arr = [3, -1, 2, 6, 4, 5, 8]
almost_sorted(arr, 2)
```
