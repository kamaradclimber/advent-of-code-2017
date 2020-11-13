# frozen_string_literal: true

require 'aoc'

class Day15 < Day
  attr_reader :a, :b

  def initialize(*)
    super
    init_a, init_b = input.split("\n").map do |l|
      Regexp.last_match(1).to_i if l.strip =~ /^Generator .+ starts with (\d+)$/
    end

    @a = Generator.new(initial_value: init_a,
                       factor: 16807,
                       mandatory_factor: (part2? ? 4 : 1))
    @b = Generator.new(initial_value: init_b,
                       factor: 48271,
                       mandatory_factor: (part2? ? 8 : 1))

    @matching = 0
  end

  def solve_part1
    judge(40_000_000)
  end

  def solve_part2
    judge(5_000_000)
  end

  DEBUG = false

  def judge(iterations)
    per_cent = iterations / 100
    iterations.times do |i|
      comp_a = a.next % 2**16
      comp_b = b.next % 2**16
      @matching += 1 if comp_a == comp_b
      puts "#{i / per_cent}% done" if DEBUG && i % per_cent == 0
    end
    @matching
  end

  class Generator
    def initialize(initial_value:, factor:, mandatory_factor:)
      @value = initial_value
      @factor = factor
      @mandatory_factor = mandatory_factor
    end

    def next
      loop do
        @value = (@value * @factor) % 2147483647
        break if @value % @mandatory_factor == 0
      end
      @value
    end
  end
end
