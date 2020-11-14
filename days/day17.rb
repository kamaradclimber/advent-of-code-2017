# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day17 < Day
  def solve_part1
    spinlock(bound: 2017, with_buffer: true)
  end

  def spinlock(bound:, with_buffer:) # rubocop:disable Metrics/PerceivedComplexity
    steps = input.to_s.to_i
    buffer = [0] if with_buffer
    current_pos = 0
    after_zero = nil
    1.upto(bound) do |i|
      insert = if i == 1
                 0
               else
                 (current_pos + steps + 1) % i
               end
      current_pos = insert
      buffer&.insert(insert + 1, i)
      after_zero = i if insert == 0
      raise if buffer && after_zero != buffer[1]
    end
    if buffer
      buffer[(current_pos + 2) % (bound + 1)]
    else
      after_zero
    end
  end

  def solve_part2
    spinlock(bound: 50_000_000 - 1, with_buffer: false)
  end
end
