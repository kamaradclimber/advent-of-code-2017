# frozen_string_literal: true

class Day
  def initialize(part:, input:)
    @part = part
    valid_part!
    @input = input
  end

  attr_reader :input

  def part1?
    @part == 1
  end

  def part2?
    @part == 2
  end

  def solve
    if part1?
      solve_part1
    else
      solve_part2
    end
  end

  def solve_part1
    raise NotImplementedError
  end

  def solve_part2
    raise NotImplementedError
  end

  private

  def valid_part!
    raise ArgumentError, "Invalid part #{@part}" unless [1,2].include?(@part)
  end
end
