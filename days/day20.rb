# frozen_string_literal: true

require 'aoc'
require 'pry'
require 'bigdecimal'

class Day20 < Day
  def particles
    @particles ||= input.split("\n").each_with_index.map { |l, id| parse_particle(l, id) }
  end

  def solve_part1
    particles.each_with_index.min_by do |particle, _index|
      particle.acc.manhattan
    end[1]
  end

  # does not find the correct solution
  def solve_part2
    # puts "There are #{particles.size} particles in this universe"
    collisions = find_all_collisions(particles)
    collided = Set.new
    while collisions.any?
      collided_indices = find_first_collisions(collisions)
      collided += collided_indices
      collisions.reject! do |particle_pair, _|
        collided.include?(particle_pair[0]) || collided.include?(particle_pair[1])
      end
      # puts "#{collisions.size} remaining collisions"
    end
    particles.size - collided.size
  end

  # @return [Array<Integer>] list of particles id that will collide first
  def find_first_collisions(collisions)
    collision_time = collisions.map { |_, times| times.min }.min
    simultaneous_collisions = collisions.select { |_, times| times.min == collision_time }.keys

    simultaneous_collisions.flatten.uniq.tap do |collided_indices|
      # puts "#{collision_time}: #{collided_indices.join(', ')} just collided"
    end
  end

  def find_all_collisions(particles)
    collisions = {}
    particles.each_with_index do |p1, i1|
      particles.each_with_index do |p2, i2|
        next if i1 >= i2 # avoid computing half of the collision matrix

        intersections = p1.intersects(p2)
        collisions[[i1, i2]] = intersections if intersections.any?
      end
    end
    collisions
  end

  def parse_particle(line, id)
    unless line =~ /p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/
      raise ArgumentError, line
    end

    pos =   Vector.new(x: Regexp.last_match(1), y: Regexp.last_match(2), z: Regexp.last_match(3))
    speed = Vector.new(x: Regexp.last_match(4), y: Regexp.last_match(5), z: Regexp.last_match(6))
    acc =   Vector.new(x: Regexp.last_match(7), y: Regexp.last_match(8), z: Regexp.last_match(9))
    Particle.new(pos: pos, speed: speed, acc: acc, id: id)
  end

  class Vector
    attr_accessor :x, :y, :z

    def initialize(x:, y:, z:)
      @x = BigDecimal(x)
      @y = BigDecimal(y)
      @z = BigDecimal(z)
    end

    def manhattan
      x.abs + y.abs + z.abs
    end

    def ==(other)
      x == other.x && y == other.y && z == other.z
    end
    alias eql? ==

    def hash
      manhattan
    end
  end

  class Particle
    attr_reader :acc, :initial_pos, :initial_speed

    def initialize(pos:, speed:, acc:, id:)
      @initial_pos = pos
      @initial_speed = speed
      @acc = acc
      @id = id
    end

    def pos(time)
      # time is discrete so formula is a bit tweaked to match examples
      Vector.new(
        x: @initial_pos.x + time * @initial_speed.x + time * (time + 1) * @acc.x / 2,
        y: @initial_pos.y + time * @initial_speed.y + time * (time + 1) * @acc.y / 2,
        z: @initial_pos.z + time * @initial_speed.z + time * (time + 1) * @acc.z / 2
      )
    end

    # @return [Array<Integer>] time of intersections along 3 axis
    def intersects(other)
      intersects_x = intersections(other, :x)
      intersects_y = intersections(other, :y)
      intersects_z = intersections(other, :z)
      times_of_intersections = intersects_x & intersects_y & intersects_z
      times_of_intersections.to_a
    end

    # @return [Array<Integer>] time of intersections along axis
    def intersections(other, axis)
      a = (acc.send(axis) - other.acc.send(axis)).to_f / 2
      b = initial_speed.send(axis) - other.initial_speed.send(axis) + (acc.send(axis) - other.acc.send(axis)).to_f / 2
      c = initial_pos.send(axis) - other.initial_pos.send(axis)
      if a == 0
        if b == 0
          Solution::INFINITE
        else
          sol = -c.to_f / b
          Solution.new([sol])
        end
      else
        discriminant = b**2 - 4 * a * c
        return Solution::EMPTY if discriminant < 0

        sqrt = Math.sqrt(discriminant)
        return Solution::EMPTY unless sqrt.integer?

        x1 = (-b - sqrt).to_f / (2 * a)
        x2 = (-b + sqrt).to_f / (2 * a)
        Solution.new([x1, x2])
      end
    end
  end

  class ::Numeric
    def integer?
      to_i == self
    end
  end

  class Solution
    def initialize(array)
      @array = array.select(&:integer?).select(&:positive?) if array.is_a?(Array)
    end

    INFINITE = Solution.new(Object.new)
    EMPTY = Solution.new(Object.new)

    def select(&block)
      case self
      when INFINITE, EMPTY
        self
      else
        Solution.new(@array.select { |el| block.call(el) })
      end
    end

    def to_a
      case self
      when INFINITE
        raise NotImplementedError
      when EMPTY
        []
      else
        @array.to_a.map(&:to_i)
      end
    end

    def intersection(other)
      if other == INFINITE
        self
      elsif self == INFINITE
        other
      elsif other == EMPTY || self == EMPTY
        EMPTY
      else
        Solution.new(to_a & other.to_a)
      end
    end
    alias & intersection
  end
end
