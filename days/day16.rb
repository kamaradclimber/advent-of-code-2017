# frozen_string_literal: true

require 'aoc'

class Day16 < Day
  def initialize(input:, part:, size:)
    super(part: part, input: input)
    @programs = ('a'..'z').to_a.take(size)
  end

  def solve_part1
    moves = input.split(',').map(&:strip)
    dance(moves)
    @programs.join
  end

  private

  def dance(moves)
    moves.each do |move|
      case move
      when /^s(\d+)/
        spin(Regexp.last_match(1).to_i)
      when %r{^x(\d+)/(\d+)}
        exchange(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i)
      when %r{^p(.)/(.)}
        partner(Regexp.last_match(1), Regexp.last_match(2))
      end
    end
  end

  def spin(count)
    @programs = @programs.drop(@programs.size - count) + @programs.take(@programs.size - count)
  end

  def exchange(i, j)
    tmp = @programs[i]
    @programs[i] = @programs[j]
    @programs[j] = tmp
  end

  def partner(a, b)
    a_pos = @programs.find_index { |c| c == a }
    b_pos = @programs.find_index { |c| c == b }
    exchange(a_pos, b_pos)
  end
end
