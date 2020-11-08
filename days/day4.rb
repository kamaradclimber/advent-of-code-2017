# frozen_string_literal: true

require 'aoc'

class Day4 < Day
  def solve_part1
    input.split("\n").select { |phrase| part1_valid?(phrase) }.count
  end

  def part1_valid?(passphrase)
    passphrase.split(' ').tally.all? do |_word, count|
      count == 1
    end
  end

  def solve_part2
    input.split("\n").select { |phrase| part2_valid?(phrase) }.count
  end

  def part2_valid?(passphrase)
    passphrase
      .split(' ')
      .map { |word| word.chars.sort }
      .tally
      .all? do |_word, count|
      count == 1
    end
  end
end
