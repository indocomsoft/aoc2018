# frozen_string_literal: true

require 'parallel'
class DayEleven
  def initialize
    @data = 9005
    @map = build_map
  end

  def partone
    result = sum(1, 1, @map, 3)
    result_coord = [1, 1]
    (1..298).each do |x|
      (1..298).each do |y|
        tmp = sum(x, y, @map, 3)
        if tmp > result
          result = tmp
          result_coord = [x, y]
        end
      end
    end
    [result, result_coord]
  end

  def parttwo
    results = Parallel.map(1..300, in_processes: 4) do |s|
      result = sum(1, 1, @map, 1)
      result_coord = [1, 1]
      puts "Doing size #{s}"
      (1..(300 - s + 1)).each do |x|
        (1..(300 - s + 1)).each do |y|
          tmp = sum(x, y, @map, s)
          next unless tmp > result

          result = tmp
          result_coord = [x, y]
        end
      end
      [result, result_coord, s]
    end
    results.max_by(&:first)
  end

  private

  def build_map
    Array.new(301) do |x|
      Array.new(301) do |y|
        rack_id = x + 10
        power_level = rack_id * y
        power_level += @data
        power_level *= rack_id
        (power_level.digits[2] || 0) - 5
      end
    end
  end

  def sum(x, y, map, size)
    ret = 0
    (0...size).each do |x_offset|
      (0...size).each do |y_offset|
        ret += map[x + x_offset][y + y_offset]
      end
    end
    ret
  end
end

# DRIVER
d11 = DayEleven.new
p d11.partone
p d11.parttwo
