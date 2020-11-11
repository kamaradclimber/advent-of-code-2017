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
      break if traverse_firewall(@firewall, initial_tick: delay).empty?

      delay += 1
    end

    delay
  end

  # @param firewall [Hash<int, Scanner>]
  # @return [Array<Integer>] severities of the trip
  def traverse_firewall(firewall, initial_tick: 0)
    packet_layer = -1
    severities = []
    max_layer = firewall.keys.max
    tick = initial_tick
    until packet_layer > max_layer
      packet_layer += 1
      severities << packet_layer * firewall[packet_layer].range if firewall[packet_layer]&.position(tick) == 0
      break if part2? && severities.any?

      tick += 1
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
    attr_reader :range

    # @param depth [Integer] layer of this scanner
    # @param range [Integer] depth of the scanner
    def initialize(depth:, range:)
      @depth = depth
      @range = range
    end

    def position(tick)
      virtual_pos = tick % (2 * range - 2)
      if virtual_pos < range
        virtual_pos
      else
        range - (tick % (range - 1)) - 1
      end
    end
  end
end
