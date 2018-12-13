# frozen_string_literal: true

class DayTwelve
  def initialize
    read_input
  end

  def partone
    state = @state.each_char.each_with_index.each_with_object(Hash.new('.')) do |x, hash|
      char, index = x
      hash[index] = char
    end
    calculate(state, 20)
  end

  def parttwo
    state = @state.each_char.each_with_index.each_with_object(Hash.new('.')) do |x, hash|
      char, index = x
      hash[index] = char
    end
    calculate(state, 50_000_000_000)
  end

  private

  def calculate(state, num_gen)
    result = state.dup
    sum = result.select { |_, v| v == '#' }.reduce(0) { |acc, x| acc + x.first }
    diff = 0
    num_gen.times do |g|
      new_state = Hash.new('.')
      ((result.keys.min - 2)..(result.keys.max + 2)).map do |i|
        key = ((i - 2)..(i + 2)).reduce('') { |acc, j| acc + result[j] }
        new_state[i] = @subs[key] || '.'
      end
      result = new_state
      new_sum = result.select { |_, v| v == '#' }.reduce(0) { |acc, x| acc + x.first }
      new_diff = new_sum - sum
      return sum + (num_gen - g) * diff if new_diff == diff

      diff = new_diff
      sum = new_sum
    end
    sum
  end

  def read_input
    input = IO.readlines('../input').map(&:chomp)
    @state = input.first.match(/initial state: (.*)/).captures.first
    @subs = input[2..-1].map { |line| line.split(' => ') }.to_h
  end
end

# DRIVER
d12 = DayTwelve.new
p d12.partone
p d12.parttwo
