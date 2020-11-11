# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day10 < Day
  def initialize(input:, part:, circular_list_size: 256)
    super(input: input, part: part)
    @knot_hash = KnotHash.new(input: input, circular_list_size: circular_list_size)
  end

  def solve_part1
    lengthes = input.split(',').map(&:strip).map(&:to_i)
    @knot_hash.round(lengthes)
    @knot_hash.list[0] * @knot_hash.list[1]
  end

  def solve_part2
    @knot_hash.compute_hash
  end
end
