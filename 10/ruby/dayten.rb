# frozen_string_literal: true

require 'set'

class DayTen
  def initialize
    @data = read_input
    @cols = `tput cols`.to_i
    @lines = `tput lines`.to_i
    @iterations = 11_000
  end

  def all_parts
    c = []
    v = []
    @data.each do |line|
      x, y, v_x, v_y = line
      c << [x, y]
      v << [v_x, v_y]
    end
    rendered = nil
    size = bounding_box_size(c)
    @iterations.times do |i|
      c = c.zip(v).map do |point, velocity|
        [point.first + velocity.first, point.last + velocity.last]
      end
      new_size = bounding_box_size(c)
      next unless new_size[0] + new_size[1] <= size[0] + size[1] &&
                  new_size[0] < @cols && new_size[1] < @lines

      rendered = [i + 1, render_points(c)]
      size = new_size
    end
    rendered
  end

  private

  def bounding_box_size(c)
    min_x, max_x = c.map(&:first).minmax
    min_y, max_y = c.map(&:last).minmax
    [max_x - min_x + 1, max_y - min_y + 1]
  end

  def render_points(c)
    set = Set.new(c)
    min_x, max_x = c.map(&:first).minmax
    min_y, max_y = c.map(&:last).minmax
    (min_y..max_y).flat_map do |y|
      (min_x..max_x).map { |x| set.include?([x, y]) ? '#' : '.' }.join
    end.join("\n")
  end

  def read_input
    IO
      .readlines('../input')
      .map do |line|
        line
          .match(/position=<(.*), (.*)> velocity=<(.*), (.*)>/)
          .captures
          .map(&:to_i)
      end
  end
end

# DRIVER
d7 = DayTen.new
time, rendered = d7.all_parts
puts rendered
puts "time = #{time}"
