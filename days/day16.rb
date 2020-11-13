# frozen_string_literal: true

require 'aoc'

class Day16 < Day
  def initialize(input:, part:, size:)
    super(part: part, input: input)
    @move = Move.new(size)
  end

  def solve_part1
    moves = input.split(',').map(&:strip)
    puts "#{moves.size} moves"
    dance(moves)
    @move.to_s
  end

  def solve_part2
    moves = input.split(',').map(&:strip)
    known_positions = {}
    known_positions[@move.to_s] = 0
    i = 1
    target = 1_000_000_000
    while i < target
      dance(moves)
      signature = @move.to_s
      if known_positions.key?(signature)
        period = i - known_positions[signature]
        # puts "Found loop of period #{period}"
        # jump. Technically we could look for the solution directly in known_positions for signature at "i + period"
        i += ((target - i) / period) * period
        # puts "Jumping to iteration #{i}"
        known_positions = {}
      else
        known_positions[signature] = i
        i += 1
      end
    end
    @move.to_s
  end

  private

  def dance(moves)
    moves.each do |move|
      case move
      when /^s(\d+)/
        @move.spin(Regexp.last_match(1).to_i)
      when %r{^x(\d+)/(\d+)}
        @move.exchange(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i)
      when %r{^p(.)/(.)}
        @move.partner(Regexp.last_match(1), Regexp.last_match(2))
      end
    end
  end

  # a move represented by a hash where:
  # - keys are the program (letter)
  # - values are the final position
  class Move
    attr_reader :inner_hash, :size

    # @param size [Integer] number of programs in the dance
    def initialize(size)
      @size = size
      @inner_hash = ('a'..'z').to_a.take(size).each_with_index.to_a.to_h
    end

    def to_s
      @inner_hash.sort_by { |_, position| position }.map(&:first).join
    end

    # @param count [Integer] count of program that spin
    def spin(count)
      inner_hash.transform_values! do |position|
        if position >= size - count
          position - (size - count)
        else
          position + count
        end
      end
    end

    def exchange(i, j)
      i_index = nil
      j_index = nil
      inner_hash.each do |index, k|
        i_index = index if k == i
        j_index = index if k == j
      end
      inner_hash[i_index] = j
      inner_hash[j_index] = i
    end

    def partner(a, b)
      tmp = inner_hash[a]
      inner_hash[a] = inner_hash[b]
      inner_hash[b] = tmp
    end

    def apply(other_move); end
  end
end
