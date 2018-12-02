require 'set'
def find
  nums = File.readlines('../input').map(&:to_i)
  set = Set.new
  sum = 0
  loop do
    nums.each do |i|
      sum += i
      return sum unless set.add?(sum)
    end
  end
end

p find
