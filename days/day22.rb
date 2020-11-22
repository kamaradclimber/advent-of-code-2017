# frozen_string_literal: true

require 'aoc'

class Day22 < Day
  def parse_input
    lines = input.split("\n")
    initial_x = lines.first.chars.size / 2
    initial_y = lines.size / 2
    infected_nodes = Set.new
    lines.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        infected_nodes << [x, y] if char == '#'
      end
    end
    worm = if part1?
             Worm.new(x: initial_x, y: initial_y, direction: Direction::UP)
           else
             ResistantWorm.new(x: initial_x, y: initial_y, direction: Direction::UP)
           end
    grid = Grid.new(infected_nodes: infected_nodes)
    [worm, grid]
  end

  def solve_part1
    worm, grid = parse_input

    10000.times { worm.run_once(grid) }
    grid.infections
  end

  def solve_part2
    worm, grid = parse_input
    10_000_000.times do
      worm.run_once(grid)
    end
    grid.infections
  end

  class Grid
    attr_reader :infections

    CLEAN = 0
    INFECTED = 1
    FLAGGED = 2
    WEAKENED = 3

    # @param infected_nodes [Set] infected nodes set
    def initialize(infected_nodes:)
      @infected_nodes = infected_nodes.map { |k| [k, INFECTED] }.to_h
      @infections = 0
    end

    def node_status(position)
      @infected_nodes[position] || CLEAN
    end

    def infected?(position)
      @infected_nodes[position] == INFECTED
    end

    def infect(position)
      @infections += 1
      @infected_nodes[position] = INFECTED
    end

    def weaken(position)
      @infected_nodes[position] = WEAKENED
    end

    def flag(position)
      @infected_nodes[position] = FLAGGED
    end

    def clean(position)
      @infected_nodes.delete(position)
    end
  end

  class Worm
    def initialize(x:, y:, direction:)
      @x = x
      @y = y
      @direction = direction
    end

    def run_once(grid)
      if grid.infected?(position)
        turn_right
        grid.clean(position)
      else
        turn_left
        grid.infect(position)
      end
      move
    end

    def position
      [@x, @y]
    end

    def move
      @x, @y = case @direction
               when Direction::UP
                 [@x, @y - 1]
               when Direction::DOWN
                 [@x, @y + 1]
               when Direction::LEFT
                 [@x - 1, @y]
               when Direction::RIGHT
                 [@x + 1, @y]
               end
    end

    def turn_left
      @direction = case @direction
                   when Direction::UP
                     Direction::LEFT
                   when Direction::DOWN
                     Direction::RIGHT
                   when Direction::LEFT
                     Direction::DOWN
                   when Direction::RIGHT
                     Direction::UP
                   end
    end

    def reverse
      turn_left
      turn_left
    end

    def turn_right
      # of course we could optimize this
      3.times { turn_left }
    end
  end

  class ResistantWorm < Worm
    def run_once(grid)
      case grid.node_status(position)
      when Grid::CLEAN
        turn_left
        grid.weaken(position)
      when Grid::WEAKENED
        # nothing, continue
        grid.infect(position)
      when Grid::INFECTED
        turn_right
        grid.flag(position)
      when Grid::FLAGGED
        grid.clean(position)
        reverse
      end
      move
    end
  end

  class Direction
    UP = Object.new
    DOWN = Object.new
    LEFT = Object.new
    RIGHT = Object.new
  end
end
