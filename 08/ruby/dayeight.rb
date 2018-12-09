# frozen_string_literal: true

class DayEight
  def initialize
    @data = read_input
  end

  def partone
    process_partone(@data).first
  end

  def parttwo
    process_parttwo(@data).first
  end

  private

  def process_partone(data)
    num_child, num_metadata, *cur_data = data
    acc = 0
    num_child.times do
      sum_metadata, cur_data = process_partone(cur_data)
      acc += sum_metadata
    end
    acc += cur_data[0, num_metadata].reduce(:+)
    [acc, cur_data[num_metadata..-1]]
  end

  def process_parttwo(data)
    num_child, num_metadata, *cur_data = data
    if num_child.zero?
      val = cur_data[0, num_metadata].reduce(:+)
      return [val, cur_data[num_metadata..-1]]
    end
    child_vals = Array.new(num_child) do
      val, cur_data = process_parttwo(cur_data)
      val
    end
    val = cur_data[0, num_metadata]
          .map { |i| child_vals[i - 1] }
          .compact
          .reduce(:+)
    [val || 0, cur_data[num_metadata..-1]]
  end

  def read_input
    IO.read('../input').chomp.split(' ').map(&:to_i).freeze
  end
end

# DRIVER
d8 = DayEight.new
p d8.partone
p d8.parttwo
