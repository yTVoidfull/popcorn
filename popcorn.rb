class Node

  def initialize (name, value, connections)
    @name = name
    @value = value
    @connections = connections
  end

  def set_connections(connections)
    @connections = connections
  end

  def get_connections
    @connections
  end

  def get_value
    @value
  end

end

class Popcorn

  # this method assumes that node value in [values] and connections in [connections] have the same index
  def initialize (values, connections)
    @nodes = []
    @node_names = []

    (0..values.size - 1).each do |i|
      name = 'node' + i.to_s

      @node_names.push(name)

      @nodes.push(Node.new(name, values[i] , connections[i]))
    end
  end

  def get_nodes
    @nodes
  end

  def find_node_by_name(name)
    @nodes[@node_names.index(name)]
  end

  def can_move_to(node, blocked)
    to = []
    connections = node.get_connections

    connections.each do |i|
      to.push(i) if @node_names.include?(i) && !blocked.include?(i)
    end

    # return all the nodes that are in connections but not in blocked
    to
  end

  def get_path (previous_node, node, blocked, iterations, val, values)
    # exit condition
    unless iterations == 0

      # finds where it can move from [node] considering blocked nodes
      can_move_to(find_node_by_name(node), blocked.clone.push(previous_node)).each do |i|
        node_val = find_node_by_name(i).get_value

        # gets a new value from: the one it got so far - [val] and current node value - [node_val]
        values.push(val + node_val)

        # continues to 'move' to another node and repeat the whole process
        get_path(node, i, blocked.clone.push(node), iterations-1, val + node_val, values)
      end
    end
  end

  def get_potential_words
    values = []

    @node_names.each do |i|
      get_path('',i,[],@nodes.length,find_node_by_name(i).get_value,values)
    end

    values.uniq
  end

  def get_words
    words = {}

    File.open('words.txt') do |file|
      file.each do |line|
        words[line.strip] = true
      end
    end

    potential_words = get_potential_words

    valid = []

    potential_words.each do |i|
      valid.push(i) unless words[i] == nil
    end

    valid
  end

end

node_values = %w(p o r n a p o c)

connections = [ %w(node1 node2 node3 node4),
                %w(node0 node3 node4 node5),
                %w(node0 node3 node6),
                %w(node0 node1 node2 node4 node6 node7),
                %w(node0 node1 node3 node5 node6 node7),
                %w(node1 node4 node7),
                %w(node2 node3 node4 node7),
                %w(node3 node4 node5 node6),
              ]

poppy = Popcorn.new(node_values, connections)

potential_words = poppy.get_potential_words
puts(potential_words.to_s)
puts(potential_words.size)

# TODO: uncomment the below lines to test which words are chosen versus the words.txt provided

# valid_words = poppy.get_words
# puts(valid_words.to_s)
# puts(valid_words.size)


