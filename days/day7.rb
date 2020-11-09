# frozen_string_literal: true

require 'aoc'

class Day7 < Day
  attr_reader :disks

  def initialize(*)
    super
    @disks = {}
    parse
  end

  def solve_part1
    # take any disk
    current_disk = @disks.values.first
    current_disk = current_disk.parent while current_disk.parent
    current_disk.name
  end

  def solve_part2
    @disks[solve_part1].balanced!
  rescue Disk::Unbalanced => e
    e.ideal_weight
  end

  def parse
    input.split("\n").each do |line|
      raise ArgumentError, "Impossible to parse line: #{line}" unless line =~ /([a-z]+) \((\d+)\)/

      if line =~ /([a-z]+) \((\d+)\)/
        @disks[Regexp.last_match(1)] = Disk.new(Regexp.last_match(1), Regexp.last_match(2).to_i)
      end
    end
    # second pass
    input.split("\n").each do |line| # rubocop:disable Style/CombinableLoops
      next unless line =~ /([a-z]+) \((\d+)\) -> (.+)$/

      above_disks = Regexp.last_match(3).split(',').map(&:strip)
      above_disks.each do |disk_name|
        @disks[disk_name].parent(@disks[Regexp.last_match(1)])
        @disks[Regexp.last_match(1)].add_child(@disks[disk_name])
      end
    end
  end

  class Disk
    attr_reader :name, :weight, :children

    # @param name [String]
    # @param weight [Integer]
    # @param below [Disk,NilClass] the disk below it, if any
    def initialize(name, weight)
      @name = name
      @weight = weight
      @children = []
    end

    # @param below [Disk] the disk below self
    def parent(disk = nil)
      @parent = disk if disk
      @parent
    end

    # @param below [Disk] a new child
    def add_child(disk)
      @children << disk
    end

    def full_weight
      @full_weight ||= @weight + @children.map(&:full_weight).sum
    end

    def balanced!
      @children.each(&:balanced!)
      weights = @children.map(&:full_weight)
      return true if weights.size < 2
      return true if weights.uniq.size == 1

      weight_counts = weights.tally
      invalid_weight = weight_counts.find { |_w, count| count == 1 }.first
      invalid_child = @children.find { |child| child.full_weight == invalid_weight }

      puts invalid_child.name
      raise Unbalanced.new(
        "#{invalid_child.name} is unbalanced",
        invalid_child,
        weights.find { |w| w != invalid_weight }
      )
    end

    class Unbalanced < RuntimeError
      def initialize(message, disk, other_weights)
        super(message)
        @other_weights = other_weights
        @disk = disk
      end

      def ideal_weight
        @other_weights - @disk.children.map(&:full_weight).sum
      end
    end
  end
end
