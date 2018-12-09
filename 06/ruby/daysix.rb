require 'set'
class DaySix
  def initialize
    @data = read_input
    @x_min, @x_max = @data.map(&:first).minmax
    @y_min, @y_max = @data.map(&:last).minmax
    @x_range = @x_min..@x_max
    @y_range = @y_min..@y_max
    freeze
  end

  def partone
    distances = Array.new(@data.size) { 0 }
    @x_range.each do |x|
      @y_range.each do |y|
        i = @data.find_index([x, y])
        if i
          distances[i] += 1
          next
        end
        nearest = find_nearest(x, y)
        distances[nearest] += 1 if nearest
      end
    end
    candidates =
      @data
      .each_with_index
      .select do |c, _i|
        [@x_min, @x_max].all? { |x| c.first != x } &&
          [@y_min, @y_max].all? { |y| c.last != y }
      end
      .map(&:last)
      .to_set
    distances
      .each_with_index
      .select { |_, i| candidates.include?(i) }
      .map(&:first)
      .max
  end

  def parttwo
    limit = 10_000
    counter = 0
    @x_range.each do |x|
      @y_range.each do |y|
        total_dist = @data.map { |c| find_distance([x, y], c) }.reduce(:+)
        counter += 1 if total_dist < limit
      end
    end
    counter
  end

  private

  def find_distance(c1, c2)
    c1_x, c1_y = c1
    c2_x, c2_y = c2
    (c1_x - c2_x).abs + (c1_y - c2_y).abs
  end

  def find_nearest(x, y)
    tmp = @data
          .each_with_index
          .map do |c, i|
      [i, find_distance([x, y], c)]
    end
    min = tmp.min_by(&:last).last
    all_min = tmp.select { |x| x.last == min }.map(&:first)
    all_min.first if all_min.size == 1
  end

  def read_input
    IO
      .readlines('../input')
      .map { |line| line.chomp.split(', ').map(&:to_i) }
      .freeze
  end
end

# DRIVER
d6 = DaySix.new
p d6.partone
p d6.parttwo
