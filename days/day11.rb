# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day11 < Day
  def solve_part1
    all_steps = input.split(',')
    distance_from_origin(all_steps)
  end

  # very suboptimal way of find the max
  # we should compute that iteratively anyway
  def solve_part2
    all_steps = input.split(',')
    (all_steps.size - 1).times.map do |i|
      distance_from_origin(all_steps.take(i+1))
    end.max
  end

  def distance_from_origin(all_steps)
    tallied_steps = all_steps.tally
    loop do
      reduce(tallied_steps)
      remaining_directions = tallied_steps.select { |_, steps| steps > 0 }
      case remaining_directions.size
      when 0, 1
        return remaining_directions.values.sum
      when 2
        return remaining_directions.values.sum if contiguous?(*remaining_directions.keys)
      end
      expand(tallied_steps)
    end
  end

  def contiguous?(dir1, dir2)
    expanded_directions[dir1].include?(dir2)
  end

  # reduce obvious opposite directions
  def reduce(tallied_steps)
    tallied_steps.default = 0
    opposite_directions.each do |a, b|
      if tallied_steps[a] <= tallied_steps[b]
        tallied_steps[b] -= tallied_steps[a]
        tallied_steps[a] = 0
      end
    end
  end

  def expand(tallied_steps)
    # a bit of random here will help us to get out of positions that otherwise lead to a cycle of positions
    dir_to_expand = tallied_steps.select { |_, count| count > 0 }.to_a.sample(1).first&.first
    raise "No direction to expand" unless dir_to_expand

    expanded_directions[dir_to_expand].each do |dir|
      tallied_steps[dir] += tallied_steps[dir_to_expand]
    end
    tallied_steps[dir_to_expand] = 0
  end

  def directions
    %w[n ne se s sw nw]
  end

  def expanded_directions
    directions.each_with_index.map do |dir, index|
      prev = directions[(index - 1) % directions.size]
      succ = directions[(index + 1) % directions.size]
      [dir, [prev, succ]]
    end.compact.to_h
  end

  def opposite_directions
    directions.each_with_index.map do |dir, index|
      [dir, directions[(index + directions.size / 2) % directions.size]]
    end.to_h
  end
end
