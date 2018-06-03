# There are many ways to implement these methods, feel free to add arguments
# to methods as you see fit, or to create helper methods.

class BinarySearchTree
  attr_accessor :root
  def initialize
    @root = nil
  end

  def insert(value)
    @root = insert_node(@root, value)
  end

  def find(value, tree_node = @root)
    return nil if tree_node.nil?
    return tree_node if tree_node.value == value

    if value < tree_node.value
      find(value, tree_node.left)
    else
      find(value, tree_node.right)
    end
  end

  def delete(value)
    @root = delete_from_tree(@root, value)
  end

  # helper method for #delete:
  def maximum(tree_node = @root)
    while tree_node.right
      tree_node = tree_node.right
    end
    tree_node
  end

  def depth(tree_node = @root)
    if tree_node.nil?
      return -1
    else
      left_depth = depth(tree_node.left)
      right_depth = depth(tree_node.right)

      if left_depth > right_depth
        return left_depth + 1
      else
        return right_depth + 1
      end
    end
  end

  def is_balanced?(tree_node = @root)
    (depth(tree_node.left) - depth(tree_node.right)).abs <= 1
  end

  def in_order_traversal(tree_node = @root, arr = [])
  end

  def parent(value, tree_node = @root)
    if tree_node.left.value == value || tree_node.right.value == value
      return tree_node
    end
    return nil if tree_node.nil?

    if value < tree_node.value
      parent(value, tree_node.left)
    elsif value > tree_node.value
      parent(value, tree_node.right)
    end
  end

  private
  # optional helper methods go here:
  def insert_node(node, value)
    return BSTNode.new(value) if node.nil?
    if value <= node.value
      node.left = insert_node(node.left, value)
    else
      node.right = insert_node(node.right, value)
    end
    node
  end

  def delete_from_tree(node, value)
    if node.value == value
      # why does this work?
      node = remove(node)
    elsif value < node.value
      node.left = delete_from_tree(node.left, value)
    elsif value > node.value
      node.right = delete_from_tree(node.right, value)
    end
    node
  end

  def remove(node)
    if !node.left && !node.right
      nil
    elsif node.left && node.right
      r = maximum(node.left)
      if r.left
        parent(r.value).right = r.left
      end
      r.left = node.left
      r.right = node.right

      r
    elsif node.left
      node.left
    elsif node.right
      node.right
    end
  end


end
