# frozen_string_literal: true

require 'aoc'

class Day13 < Day
  def solve_part1
    parse_input
    traverse_firewall(@firewall).sum
  end

  def solve_part2
    parse_input
    delay = 0

    loop do
      puts "Delay #{delay}" if delay % 10000 == 0
      firewall_copy = @firewall.transform_values(&:dup)
      break if traverse_firewall(firewall_copy).empty?

      @firewall.values.each(&:tick)
      delay += 1
    end

    delay
  end

  def print_firewall(firewall, cur_layer: nil)
    layers = firewall.keys.max + 1
    max_line = firewall.values.map(&:range).max
    max_line.times do |line|
      layers.times do |layer|
        chars = if firewall[layer]
                  if firewall[layer].position == line
                    '[S] '
                  elsif firewall[layer].range > line
                    '[ ]'
                  else
                    '... '
                  end
                else
                  '... '
                end
        chars.gsub('[', '(').gsub(']', ')') if cur_layer == layer
        print chars
      end
      puts ''
    end
  end

  # @param firewall [Hash<int, Scanner>]
  # @return [Array<Integer>] severities of the trip
  def traverse_firewall(firewall)
    packet_layer = -1
    severities = []
    max_layer = firewall.keys.max
    until packet_layer > max_layer
      packet_layer += 1
      severities << packet_layer * firewall[packet_layer].range if firewall[packet_layer]&.position == 0
      break if part2? && severities.any?

      firewall.values.each(&:tick)
    end
    severities
  end

  def parse_input
    @firewall = input.split("\n").map do |line|
      raise "Impossible to parse line: #{line}" unless line =~ /^(\d+): (\d+)$/

      [Regexp.last_match(1).to_i, Scanner.new(depth: Regexp.last_match(1).to_i, range: Regexp.last_match(2).to_i)]
    end.to_h
  end

  class Scanner
    attr_reader :range, :position

    # @param depth [Integer] layer of this scanner
    # @param range [Integer] depth of the scanner
    # @param initial_position [Integer]
    # @param inital_direction [Integer]
    def initialize(depth:, range:, initial_position: 0, initial_direction: 1)
      @depth = depth
      @range = range
      @position = initial_position
      @direction = initial_direction
    end

    def tick
      @position += @direction
      @direction *= -1 if @position == @range - 1 || @position == 0
    end

    def dup
      Scanner.new(depth: @depth, range: range,
                  initial_position: position,
                  initial_direction: @direction)
    end
  end
end
