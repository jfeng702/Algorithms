class DynamicProgramming

  def initialize
    @blair_cache = {1 => 1, 2 => 2}
    @frog_cache = {
          1 => [[1]],
          2 => [[1,1], [2]],
          3 => [[1,1,1], [1,2], [2,1], [3]]
        }
  end

  def blair_nums(n)
    # return @blair_cache[n] unless @blair_cache[n].nil?
    #
    # ans = blair_nums(n-1) + blair_nums(n-2) + (n-1)*2-1
    # @blair_cache[n] = ans
    # return ans

    # Bottom Up Approach
    cache = blair_cache_builder(n)
    cache[n]
  end

  def blair_cache_builder(n)
    cache = { 1 => 1, 2 => 2}
    return cache if n < 3
    (3..n).each do |i|
      cache[i] = cache[i-1] + cache[i - 2] + (i-1)*2-1
    end
    cache
  end

  def frog_hops_bottom_up(n)
    cache = frog_cache_builder(n)
    cache[n]
  end

  def frog_cache_builder(n)
    cache = {
      1 => [[1]],
      2 => [[1,1], [2]],
      3 => [[1,1,1], [1,2], [2,1], [3]]
    }
    return cache if n < 4

    (4..n).each do |i|
      current_hops = []
      cache[i-1].each do |hop|
        current_hops << (hop.dup << 1)
      end
      cache[i-2].each do |hop|
        current_hops << (hop.dup << 2)
      end
      cache[i-3].each do |hop|
        current_hops << (hop.dup << 3)
      end
      cache[i] = current_hops
    end
    cache
  end

  def frog_hops_top_down(n)
    return @frog_cache[n] unless @frog_cache[n].nil?
    
  end

  def frog_hops_top_down_helper(n)

  end

  def super_frog_hops(n, k)

  end

  def knapsack(weights, values, capacity)

  end

  # Helper method for bottom-up implementation
  def knapsack_table(weights, values, capacity)

  end

  def maze_solver(maze, start_pos, end_pos)
  end
end
