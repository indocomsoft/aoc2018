require 'time'
class DayFour
  class << self
    def partone
      hash = {}
      cur = nil
      start_sleep = nil
      read_input.each do |line|
        date, desc = line
        match = desc.match(/Guard #(\d+) begins shift/)
        if match
          cur = match.captures.first.to_i
        elsif desc == 'falls asleep'
          start_sleep = date
        elsif desc == 'wakes up'
          hash[cur] ||= 0
          hash[cur] += date - start_sleep
        end
      end
      guard_id = hash.max_by { |_, v| v }.first
      minutes_asleep = {}
      cur = false
      read_input.each do |line|
        date, desc = line
        match = desc.match(/Guard #(\d+) begins shift/)
        cur = match.captures.first.to_i == guard_id if match
        if cur && desc == 'falls asleep'
          start_sleep = date
        elsif cur && desc == 'wakes up'
          start_min = start_sleep.min
          stop_min = date.min
          range = start_min <= stop_min ? start_min...stop_min : ((start_min..59) + (0...stop_min))
          range.each do |m|
            minutes_asleep[m] ||= 0
            minutes_asleep[m] += 1
          end
        end
      end
      min_max = minutes_asleep.max_by { |_, v| v }.first
      guard_id * min_max
    end

    def parttwo
      hash = {}
      cur = nil
      start_sleep = nil
      read_input.each do |line|
        date, desc = line
        match = desc.match(/Guard #(\d+) begins shift/)
        if match
          cur = match.captures.first.to_i
          hash[cur] ||= {}
        elsif desc == 'falls asleep'
          start_sleep = date
        elsif desc == 'wakes up'
          start_min, stop_min = [start_sleep, date].map(&:min)
          range = start_min <= stop_min ? start_min...stop_min : ((start_min..59) + (0...stop_min))
          range.each do |m|
            hash[cur][m] ||= 0
            hash[cur][m] += 1
          end
        end
      end
      result = hash
               .map { |k, v| [k, v.max_by { |_, num| num }] }
               .select(&:last)
               .max_by { |a| a.last.last }
      id = result.first
      min = result.last.first
      id * min
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
