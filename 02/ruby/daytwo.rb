class DayTwo
  class << self
    def partone
      lines_freqs = read_input.map { |line| letter_frequency(line) }
      twos = lines_freqs
             .select { |freqs| freqs.any? { |freq| freq.last == 2 } }
             .size
      threes = lines_freqs
               .select { |freqs| freqs.any? { |freq| freq.last == 3 } }
               .size
      twos * threes
    end

    def parttwo
      read_input
        .combination(2)
        .map { |comb| find_one_different(comb.first, comb.last) }
        .compact
        .first
    end

    private

    def find_one_different(a, b)
      same = a.chars.zip(b.chars).select { |x, y| x == y }.map(&:first)
      same.join if same.length == a.length - 1
    end

    def letter_frequency(str)
      str
        .each_char
        .group_by { |letter| letter }
        .map { |letter, occurrences| [letter, occurrences.size] }
    end

    def read_input
      File.readlines('../input').map(&:chomp)
    end
  end
end

# DRIVER
p DayTwo.partone
p DayTwo.parttwo
