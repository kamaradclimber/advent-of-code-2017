# frozen_string_literal: true

require 'aoc'

class Day14 < Day
  def solve_part1
    grid = build_grid
    grid.map { |line| line.map(&:to_i).sum }.sum
  end

  def solve_part2
    grid = build_grid
    all_points = []
    grid.each_with_index do |line, y|
      line.each_with_index do |square, x|
        all_points << Point.new(x: x, y: y) if square == '1'
      end
    end
    region_count = 0
    while all_points.any?
      starting_point = all_points.pop
      next unless grid[starting_point.y][starting_point.x] == '1' # got erased already

      erase_connex(grid, starting_point)
      region_count += 1
    end
    region_count
  end

  # @param grid [Array<Array<Integer>>]
  # @param point [Array<Integer>] starting point
  # Erase all points from the connex area from starting_point
  def erase_connex(grid, starting_point)
    to_visit = [starting_point]
    until to_visit.empty?
      point = to_visit.pop
      grid[point.y][point.x] = '0' # erase since we already seen it
      to_visit += point.neighbors(grid)
    end
  end

  def build_grid
    128.times.map do |i|
      knot_hash = KnotHash.new(input: "#{input}-#{i}")
      binary_knot = knot_hash.compute_hash.to_i(16).to_s(2)
      "#{'0' * (128 - binary_knot.size)}#{binary_knot}".chars
    end
  end

  class Point
    attr_reader :x, :y

    def initialize(x:, y:)
      @x = x
      @y = y
    end

    # @return [Array<Point>] all connected points on this grid
    def neighbors(grid)
      n = []
      n << Point.new(x: x - 1, y: y) if x > 0
      n << Point.new(x: x + 1, y: y) if x < grid.first.size - 1
      n << Point.new(x: x, y: y - 1) if y > 0
      n << Point.new(x: x, y: y + 1) if y < grid.size - 1
      n.select do |point|
        grid[point.y][point.x] == '1'
      end
    end
  end
end
