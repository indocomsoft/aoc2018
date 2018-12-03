class DayThree
  def initialize
    @data = read_input
    @fabric = Array.new(1000) { Array.new(1000) }
    @id_overlap = Array.new(@data.size)
    build_map
  end

  def partone
    @fabric.reduce(0) do |acc1, row|
      acc1 + row.reduce(0) { |acc2, cell| cell == 'X' ? acc2 + 1 : acc2 }
    end
  end

  def parttwo
    @id_overlap.find_index(&:!) + 1
  end

  private

  def build_map
    read_input.each_with_index do |line, i|
      id, x, y, x_range, y_range = line
      (x...(x + x_range)).each do |a|
        (y...(y + y_range)).each do |b|
          if @fabric[a][b]
            @id_overlap[@fabric[a][b] - 1] = true if @fabric[a][b].is_a? Numeric
            @id_overlap[i] = true
            @fabric[a][b] = 'X'
          else
            @fabric[a][b] = id
          end
        end
      end
    end
  end

  def read_input
    File
      .readlines('../input')
      .map do |line|
        line.chomp.match(/#(\d*) @ (\d*),(\d*): (\d*)x(\d*)/).captures.map(&:to_i)
      end
  end
end

# DRIVER
day3 = DayThree.new
p day3.partone
p day3.parttwo
