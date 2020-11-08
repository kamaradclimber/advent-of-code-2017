# frozen_string_literal: true

require 'aoc'

class Day1 < Day
  def solve_part1
    chars = input.to_s.chars
    chars << chars.first
    chars.each_cons(2).filter_map do |el, next_el|
      el.to_i if el == next_el
    end.sum
  end

  def solve_part2
    chars = input.to_s.chars
    ahead = chars.size / 2

    chars.each_with_index.filter_map do |el, index|
      el.to_i if el == chars[(index + ahead) % chars.size]
    end.sum
  end
end
