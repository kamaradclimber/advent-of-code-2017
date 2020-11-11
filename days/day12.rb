# frozen_string_literal: true

require 'aoc'

class Day12 < Day
  def initialize(*)
    super
    @programs = Hash.new do |h, k|
      h[k] = Program.new(id: k)
    end
  end

  def solve_part1
    parse_input
    connex_component(@programs[0]).size
  end

  def solve_part2
    parse_input
    groups = 0
    until @programs.empty?
      starting_program = @programs.values.first
      raise 'Impossible to find a program that is not already in one of the group' unless starting_program

      visited = connex_component(starting_program)
      groups += 1
      @programs.reject! { |_, p| visited.include?(p) }
    end
    groups
  end

  def parse_input
    input.split("\n").each do |line|
      raise "Impossible to parse line: #{line}" unless line =~ /^(\d+) <-> (.+)$/

      id = Regexp.last_match(1).to_i
      connected_to = Regexp.last_match(2).split(',').map(&:strip).map(&:to_i)
      connected_to.each do |other_id|
        @programs[id].pipes << @programs[other_id]
      end
    end
  end

  # @param initial [Program] the inital node to discover the connex component
  # @return [Enumerable<Program>] programs connected to initial
  def connex_component(initial)
    visited = Set.new
    to_visit = [initial]
    until to_visit.empty?
      visiting = to_visit.pop
      visited << visiting
      to_visit += visiting
                  .pipes
                  .reject { |p| visited.include?(p) }
                  .reject { |p| to_visit.include?(p) }
    end
    visited
  end

  class Program
    attr_reader :id

    def initialize(id:)
      @id = id
      @pipes = []
    end
    # @return pipes [Array<Program>]
    attr_reader :pipes

    def inspect
      "#{id} <-> #{pipes.map(&:id).join(', ')}"
    end
  end
end
