# frozen_string_literal: true

require 'aoc'

class Day8 < Day
  WITH_LOG = false

  def debug(message)
    puts message if WITH_LOG
  end

  def solve_part1
    run_program
  end

  def solve_part2
    run_program
    @max_register_value
  end

  def run_program
    @registers = Hash.new(0)
    input.split("\n").each do |instruction|
      execute(instruction)
      debug @registers
      @max_register_value = [@registers.values.max, @max_register_value].compact&.max
    end
    @registers.values.max
  end

  def execute(instruction)
    unless instruction =~ /^([a-z]+) (inc|dec) (-?\d+) if ([a-z]+) ((!|>|<|=)=?) (-?\d+)$/
      raise "Not matching: #{instruction}"
    end

    register_a = Regexp.last_match(1)
    op = Regexp.last_match(2)
    offset = Regexp.last_match(3)
    register_b = Regexp.last_match(4)
    comparison = Regexp.last_match(5)
    operand = Regexp.last_match(7)

    if @registers[register_b].send(comparison.to_sym, operand.to_i)
      debug "#{instruction} ✅"
      case op
      when 'inc'
        @registers[register_a] += offset.to_i
      when 'dec'
        @registers[register_a] -= offset.to_i
      else
        raise "Unknown operation #{op}"
      end
    else
      debug "#{instruction} ❌"
    end
  end
end
