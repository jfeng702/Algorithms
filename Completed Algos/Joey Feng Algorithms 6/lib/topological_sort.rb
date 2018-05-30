require_relative 'graph'
require 'byebug'

# Implementing topological sort using both Khan's and Tarian's algorithms

def topological_sort(vertices)
  sorted = []
  top = []
  # all_vertices = vertices
  # debugger
  vertices.each do |vtx|
    # p vtx.in_edges.length
    if vtx.in_edges.empty?
      top.unshift(vtx)
    end
  end

  until top.empty?
    current = top.pop
    sorted << current
    current_edges = current.out_edges.dup
    # debugger
    current_edges.each do |edge|
      # p edge.to_vertex.in_edges
      if edge.to_vertex.in_edges.size <= 1
        top.unshift(edge.to_vertex)
      end
      edge.destroy!
    end

  end

  vertices.length == sorted.length ? sorted : []
end
