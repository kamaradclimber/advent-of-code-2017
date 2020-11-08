# frozen_string_literal: true

require 'aoc'

class Day6 < Day
  attr_reader :already_seen

  def solve_part1
    solve_generic[0]
  end

  def solve_part2
    solve_generic[1]
  end

  def solve_generic
    @already_seen = {}
    banks = input.split(/\s+/).map(&:to_i)
    iterations = 0
    until already_seen.key?(banks)
      already_seen[banks] = iterations
      balance!(banks)
      iterations += 1
    end
    [iterations, iterations - already_seen[banks]]
  end

  def balance!(banks)
    max = banks.max
    bank_to_empty = banks.find_index(max)
    banks[bank_to_empty] = 0
    index = bank_to_empty + 1
    max.times do
      banks[index % banks.size] += 1
      index += 1
    end
  end
end
