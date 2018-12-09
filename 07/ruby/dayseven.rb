# frozen_string_literal: true

class DaySeven
  def initialize
    @data = read_input
    @num_workers = 5
    @additional_time = 60
  end

  def partone
    build_graph
    result = ''
    graph = @graph
    s = @no_incoming
    until s.empty?
      s.sort!
      node = s.shift
      result += node
      graph[node]&.sort&.each do |neighbour|
        graph[node].delete(neighbour)
        s << neighbour unless has_incoming?(neighbour, graph)
      end
      graph.delete(node) if graph[node]&.empty?
    end
    result
  end

  def parttwo
    build_graph
    graph = @graph.clone
    cur_t = 0
    next_t = Array.new(@num_workers)
    tasks = Array.new(@num_workers)
    queue = @no_incoming
    # Initial allocation
    until !next_t.find_index(&:nil?) || queue.empty?
      node = queue.shift
      i = next_t.find_index(&:nil?)
      next_t[i] = cur_t + get_time(node)
      tasks[i] = node
    end
    until next_t.all?(&:nil?)
      # Find the earliest to finish
      i = next_t.find_index(next_t.select(&:itself).min)
      cur_t = next_t[i]
      prev_task = tasks[i]
      next_t[i] = tasks[i] = nil
      graph[prev_task].clone&.each do |neighbour|
        graph[prev_task].delete(neighbour)
        queue << neighbour unless has_incoming?(neighbour, graph)
      end

      until !next_t.find_index(&:nil?) || queue.empty?
        node = queue.shift
        i = next_t.find_index(&:nil?)
        next_t[i] = cur_t + get_time(node)
        tasks[i] = node
      end
    end
    cur_t
  end

  private

  def get_time(node)
    @additional_time + node.ord - 'A'.ord + 1
  end

  def has_incoming?(node, graph)
    graph.values.flat_map(&:itself).uniq.include? node
  end

  def build_graph
    @nodes = @data.flatten.uniq.freeze
    @graph = {}
    @data.each do |line|
      from, to = line
      @graph[from] ||= []
      @graph[from] << to
    end
    with_incoming = @graph.values.flat_map(&:itself).uniq
    @no_incoming = @nodes - with_incoming
  end

  def read_input
    IO.readlines('../input').map do |line|
      line.chomp.match(/Step (.) must be finished before step (.) can begin./).captures
    end
      .freeze
  end
end

# DRIVER
d7 = DaySeven.new
p d7.partone
p d7.parttwo
