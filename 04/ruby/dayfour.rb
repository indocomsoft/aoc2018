require 'time'
class DayFour
  class << self
    def partone
      hash = build_hash
      guard_id = hash
                 .map { |k, v| [k, v.map { |_min, num| num }.sum] }
                 .max_by(&:last)
                 .first
      min_max = hash[guard_id].max_by { |_, v| v }.first
      guard_id * min_max
    end

    def parttwo
      result = build_hash
               .map { |k, v| [k, v.max_by { |_, num| num }] }
               .select(&:last)
               .max_by { |a| a.last.last }
      id = result.first
      min = result.last.first
      id * min
    end

    private

    def build_hash
      hash = {}
      cur = nil
      start_sleep = nil
      read_input.each do |line|
        date, desc = line
        match = desc.match(/Guard #(\d+) begins shift/)
        if match
          cur = match.captures.first.to_i
          hash[cur] ||= Hash.new(0)
        elsif desc == 'falls asleep'
          start_sleep = date
        elsif desc == 'wakes up'
          start_min, stop_min = [start_sleep, date].map(&:min)
          range = if start_min <= stop_min
                    start_min...stop_min
                  else
                    (start_min..59) + (0...stop_min)
                  end
          range.each { |m| hash[cur][m] += 1 }
        end
      end
      hash
    end

    def read_input
      File
        .readlines('../input')
        .map(&:chomp)
        .sort
        .map do |line|
          date, desc = line.match(/\[(.*)\] (.*)/).captures
          [Time.parse(date), desc]
        end
    end
  end
end

# DRIVER
p DayFour.partone
p DayFour.parttwo
