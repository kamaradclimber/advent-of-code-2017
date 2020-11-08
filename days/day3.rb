# frozen_string_literal: true

require 'aoc'

class Day3 < Day
  def initialize(*)
    super
    @part2_values = Hash.new(0)
    @part2_values[[0, 0]] = 1
  end

  # south-east number of the grid is (1 + 2n)^2 where n is the position of this number (n, -n) on the grid
  #
  def solve_part1
    x, y = coords(input)
    x.abs + y.abs
  end

  def coords(input)
    # now we have the highest south-east corner that is < input.
    ring = (0..).find do |n|
      se(n + 1) > input
    end + 1
    ring -= 1 if input == se(ring - 1)
    # puts "#{input} belongs to ring #{ring}, se value is #{se(ring)}"
    case input
    when se(ring)
      [ring, -ring]
    when (se(ring - 1)..ne(ring))
      [ring, -ring + input - se(ring - 1)]
    when (ne(ring)..nw(ring))
      [ring - (input - ne(ring)), ring]
    when (nw(ring)..sw(ring))
      [-ring, ring - (input - nw(ring))]
    else
      [-ring + (input - sw(ring)), -ring]
    end
  end

  def solve_part2
    index = 1
    index += 1 until (value = part2_value_at(index)) > input
    value
  end

  def part2_value_at(index)
    (1..index).each do |i|
      x, y = coords(i)
      next if @part2_values[[x, y]] > 0

      deltas = [
        [1, -1], [1, 0], [1, 1],
        [0, -1], [0, 1],
        [-1, -1], [-1, 0], [-1, 1]
      ]
      @part2_values[[x, y]] = deltas.map do |deltax, deltay|
        @part2_values[[x + deltax, y + deltay]]
      end.sum
    end
    @part2_values[coords(index)]
  end

  # @inefficient
  def part2_at(x, y)
    ring = if x > 0 && [x, y] == [x, -x]
             x.abs
           else
             [x.abs, y.abs].max - 1
           end
    se_index = se(ring)
    (se_index..).find { |n| coords(n) == [x, y] }
  end

  # @return [Integer] value at position (n, -n)
  def se(n)
    (2 * n + 1)**2
  end

  # @return [Integer] value at position (n, n)
  def ne(n)
    se(n - 1) + 2 * n
  end

  # @return [Integer] value at position (-n, n)
  def nw(n)
    ne(n) + 2 * n
  end

  # @return [Integer] value at position (-n, -n)
  def sw(n)
    nw(n) + 2 * n
  end
end
