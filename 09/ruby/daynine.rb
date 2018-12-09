# frozen_string_literal: true

class Marble
  attr_reader :num
  attr_accessor :ccw, :cw

  def initialize(num)
    @num = num
  end
end

class DayNine
  def initialize
    @num_players, @last_marble = read_input
  end

  def partone
    calc
  end

  def parttwo
    @last_marble *= 100
    calc
  end

  private

  def calc
    scores = Array.new(@num_players) { 0 }
    cur_marble = Marble.new(0)
    cur_marble.ccw = cur_marble.cw = cur_marble
    (1..@last_marble).each do |marble_id|
      cur_player = marble_id % @num_players
      if (marble_id % 23).zero?
        scores[cur_player] += marble_id
        7.times { cur_marble = cur_marble.ccw }
        scores[cur_player] += cur_marble.num
        cur_marble = cur_marble.cw
        cur_marble.ccw = cur_marble.ccw.ccw
        cur_marble.ccw.cw = cur_marble
      else
        cur_marble = cur_marble.cw
        new_marble = Marble.new(marble_id)
        new_marble.cw = cur_marble.cw
        new_marble.cw.ccw = new_marble
        cur_marble.cw = new_marble
        new_marble.ccw = cur_marble
        cur_marble = new_marble
      end
    end
    scores.max
  end

  def read_input
    IO
      .read('../input')
      .match(/(\d+) players; last marble is worth (\d+) points/)
      .captures
      .map(&:to_i)
  end
end

d9 = DayNine.new
p d9.partone
p d9.parttwo
