# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day21 < Day
  def initialize(input:, part:, iterations: 5)
    @iterations = iterations
    super(input: input, part: part)
  end

  def solve
    rules = input.split("\n").map do |line|
      raise ArgumentError, line unless line =~ /(.+) => (.+)/

      [Pattern.new(Regexp.last_match(1)), Pattern.new(Regexp.last_match(2))]
    end.to_h

    start = Pattern.new('.#./..#/###')

    grid = [[start]]
    @iterations.times do |iteration|
      puts "Iteration #{iteration}, #{grid.flatten.size} pattern to explore, #{pixels_on(grid)} pixels on"
      new_grid = grid.map do |grid_line|
        grid_line.map do |grid_cell|
          res = rules[grid_cell]
          raise "Argh: #{grid_cell}" unless res

          res
        end
      end
      grid = resplit(new_grid)
      # validity check but we don't need it unless debugging
      # before = pixels_on(grid)
      # after = pixels_on(new_grid)
      # raise "The resplit method has transformed the grid #{before} #{after}" unless before == after
    end
    pixels_on(grid)
  end

  def pixels_on(grid)
    grid.flatten.map { |pattern| pattern.to_s.chars.count { |c| c == '#' } }.sum
  end

  def resplit(grid)
    big_grid = grid.map do |patterns| # all pattern on the same "line"
      square_size = patterns.first.inner.size
      square_size.times.map do |line_index|
        patterns.flat_map { |pattern| pattern.inner[line_index] }
      end
    end.flatten(1)
    big_square_size = big_grid.size
    new_square_size = big_square_size.even? ? 2 : 3
    new_grid_lines = []
    big_grid.each_slice(new_square_size).map do |slice|
      line = []
      slices = slice.map { |l| l.each_slice(new_square_size).to_a }
      (big_square_size / new_square_size).times do |i|
        line << Pattern.new(slices.map { |s| s[i].join }.join('/'))
      end
      new_grid_lines << line
    end
    new_grid_lines
  end

  class Pattern
    attr_reader :inner

    def initialize(signature)
      @inner = signature.split('/').map(&:chars)
    end

    def hash
      @inner.flatten.count { |c| c == '#' }
    end

    def to_s
      inner.map(&:join).join('/')
    end

    def get(line:, column:)
      inner[line][column]
    end

    # a special equality that accept rotated/flipped versions
    def ==(other)
      all_versions.include?(other.inner)
    end

    alias eql? ==

    private

    def all_versions
      @all_versions ||= begin
        versions = [inner]
        3.times { versions << rotate(versions.last) }
        versions += versions.map { |v| flip_v(v) } + versions.map { |v| flip_h(v) }
        versions
      end
    end

    def flip_v(inner)
      [inner[2], inner[1], inner[0]]
    end

    def flip_h(inner)
      inner.map do |line|
        [line[2], line[1], line[0]]
      end
    end

    def rotate(inner)
      rotated_array = []
      inner.transpose.each do |column|
        rotated_array << column.reverse
      end
      rotated_array
    end
  end
end
