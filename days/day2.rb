# frozen_string_literal: true

require 'aoc'

class Day2 < Day
  def solve_part1
    lines = input.split("\n").map { |line| line.split(' ').map(&:to_i) }

    lines.map do |line|
      line.max - line.min
    end.sum
  end

  def solve_part2
    lines = input.split("\n").map { |line| line.split(' ').map(&:to_i) }

    lines.map do |line|
      solve_line(line)
    end.sum
  end

  def solve_line(line)
    line.combination(2).filter_map do |a, b|
      a, b = [a, b].minmax
      q, r = b.divmod(a)
      q if r == 0
    end.first
  end
end
