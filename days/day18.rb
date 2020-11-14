# frozen_string_literal: true

require 'aoc'

class Day18 < Day
  def solve_part1 # rubocop:disable Metrics/MethodLength
    @registers = Hash.new(0)
    @last_played = nil
    instructions = input.split("\n")
    i = 0
    while i >= 0 && i < instructions.size
      instruction = instructions[i]
      case instruction
      when /snd (\w+)/
        @last_played = value_of(Regexp.last_match(1))
      when /set (\w+) (\w+)/
        @registers[Regexp.last_match(1)] = value_of(Regexp.last_match(2))
      when /add (\w+) (-?\w+)/
        @registers[Regexp.last_match(1)] += value_of(Regexp.last_match(2))
      when /mul (\w+) (-?\w+)/
        @registers[Regexp.last_match(1)] = value_of(Regexp.last_match(1)) * value_of(Regexp.last_match(2))
      when /mod (\w+) (\w+)/
        @registers[Regexp.last_match(1)] %= value_of(Regexp.last_match(2))
      when /rcv (\w+)/
        if value_of(Regexp.last_match(1)) > 0
          @recovered = @last_played
          break
        end
      when /jgz (\w+) (-?\w+)/
        if value_of(Regexp.last_match(1)) > 0
          i += value_of(Regexp.last_match(2))
          next
        end
      else
        raise NotImplementedError, "#{instruction} is not handled"
      end
      i += 1
    end
    @recovered
  end

  def value_of(object)
    if object.to_i.to_s == object
      object.to_i
    else
      @registers[object]
    end
  end

  def solve_part2
    q1 = Queue.new
    q2 = Queue.new
    instructions = input.split("\n")
    p0 = Program.new(q1, q2, instructions, id: 0)
    p1 = Program.new(q2, q1, instructions, id: 1)
    loop do
      p0.run
      p1.run
      break if q1.empty? && q2.empty?
    end
    p1.sent
  end

  class Program
    attr_reader :sent, :instructions

    def initialize(send_queue, recv_queue, instructions, id:)
      @registers = Hash.new(0)
      @registers['p'] = id
      @send_queue = send_queue
      @recv_queue = recv_queue
      @instructions = instructions
      @sent = 0
      @i = 0
      @id = id
    end

    def value_of(object)
      if object.to_i.to_s == object
        object.to_i
      else
        @registers[object]
      end
    end

    def run
      while @i >= 0 && @i < instructions.size
        instruction = instructions[@i]
        case instruction
        when /snd (\w+)/
          @send_queue << value_of(Regexp.last_match(1))
          @sent += 1
        when /set (\w+) (\w+)/
          @registers[Regexp.last_match(1)] = value_of(Regexp.last_match(2))
        when /add (\w+) (-?\w+)/
          @registers[Regexp.last_match(1)] += value_of(Regexp.last_match(2))
        when /mul (\w+) (-?\w+)/
          @registers[Regexp.last_match(1)] = value_of(Regexp.last_match(1)) * value_of(Regexp.last_match(2))
        when /mod (\w+) (\w+)/
          @registers[Regexp.last_match(1)] %= value_of(Regexp.last_match(2))
        when /rcv (\w+)/
          begin
            @registers[Regexp.last_match(1)] = @recv_queue.pop(true)
          rescue ThreadError
            # there were no message, let's yield for now
            return
          end
        when /jgz (\w+) (-?\w+)/
          if value_of(Regexp.last_match(1)) > 0
            @i += value_of(Regexp.last_match(2))
            next
          end
        else
          raise NotImplementedError, "#{instruction} is not handled"
        end
        @i += 1
      end
    end
  end
end
