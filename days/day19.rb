# frozen_string_literal: true

require 'aoc'

class Day19 < Day
  def solve_part1
    @maze = input.split("\n").map(&:chars)
    position = find_entry
    @letters = []
    loop do
      position = position.next(@maze)
      @letters << position.letter if position&.letter
      break unless position
    end
    @letters.join
  end

  # @return [[Point, Direction]]
  def find_entry
    x = @maze[0].find_index { |c| c == '|' }
    Point.new(x: x, y: 0, direction: Direction::DOWN)
  end

  class Point
    attr_reader :x, :y
    attr_accessor :direction, :letter

    def initialize(x:, y:, direction: nil)
      @x = x
      @y = y
      @direction = direction
    end

    def inspect
      "(#{x}, #{y}) #{letter}"
    end

    # @param maze [Array[Array[String]]]
    # @return [Point, NilClass]
    def next(maze)
      next_point = case direction
                   when Direction::UP
                     Point.new(x: x, y: y - 1)
                   when Direction::DOWN
                     Point.new(x: x, y: y + 1)
                   when Direction::LEFT
                     Point.new(x: x - 1, y: y)
                   when Direction::RIGHT
                     Point.new(x: x + 1, y: y)
                   end
      char = maze[next_point.y][next_point.x]
      case char
      when '-', '|'
        next_point.direction = direction
      when '+'
        next_point.direction = next_direction(next_point, maze)
      when /\w/
        next_point.letter = char
        next_point.direction = direction
      when ' '
        # this is the end
        return nil
      else
        raise NotImplementedError, "Unknown char #{char.inspect}"
      end
      next_point
    end

    private

    def next_direction(next_point, maze)
      case direction
      when Direction::UP, Direction::DOWN
        if maze[next_point.y][next_point.x - 1] == ' '
          Direction::RIGHT
        else
          Direction::LEFT
        end
      when Direction::LEFT, Direction::RIGHT
        if maze[next_point.y - 1][next_point.x] == ' '
          Direction::DOWN
        else
          Direction::UP
        end
      end
    end
  end

  class Direction
    UP = Object.new
    DOWN = Object.new
    LEFT = Object.new
    RIGHT = Object.new
  end
end
