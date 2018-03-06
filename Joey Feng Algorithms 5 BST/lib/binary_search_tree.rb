# There are many ways to implement these methods, feel free to add arguments
# to methods as you see fit, or to create helper methods.
require 'bst_node'
require 'byebug'

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert_into_tree(tree_node, value)
    return BSTNode.new(value) if tree_node.nil?
    if value < tree_node.value
      tree_node.left = insert_into_tree(tree_node.left, value)
    else
      tree_node.right = insert_into_tree(tree_node)
    
  end

  def insert(value)
    @root = insert_into_tree(@root, value)
  end


  # optional helper methods go here:

end
