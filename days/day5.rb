# frozen_string_literal: true

require 'aoc'

class Day5 < Day
  def solve_part1
    jump_list = input.split(' ').map(&:to_i)
    index = 0
    step_count = 0
    while index < jump_list.size && index >= 0
      offset = jump_list[index]
      jump_list[index] += 1
      index += offset
      step_count += 1
    end
    step_count
  end

  def solve_part2
    jump_list = input.split(' ').map(&:to_i)
    index = 0
    step_count = 0
    while index < jump_list.size && index >= 0
      offset = jump_list[index]
      jump_list[index] += offset >= 3 ? -1 : 1
      index += offset
      step_count += 1
    end
    step_count
  end
end
