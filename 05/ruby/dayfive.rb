require 'set'
class DayFive
  def initialize
    @data = simplify(read_input)
  end

  def partone
    @data.size
  end

  def parttwo
    set = Set[]
    @data.each_char { |a| set.add(a.upcase) }
    set.map { |a| simplify(@data.tr(a, '').tr(a.downcase, '')).size }.min
  end

  private

  def simplify(input)
    changed = false
    result = ''
    prev = nil
    input
      .each_char
      .each_cons(2) do |a|
        if prev
          prev = nil
          next
        end
        x, y = a
        if different_case_of_same_letter?(x, y)
          prev = changed = true
        else
          result = "#{result}#{x}"
        end
      end
    result += result[-1] unless prev
    changed ? simplify(result) : result
  end

  def different_case_of_same_letter?(a, b)
    (a.bytes.first - b.bytes.first).abs == 32
  end

  def read_input
    File.readlines('../input').map(&:chomp).first
  end
end

# DRIVER
day5 = DayFive.new
p day5.partone
p day5.parttwo
