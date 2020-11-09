# frozen_string_literal: true

require 'aoc'

class Day9 < Day
  def solve_part1
    root_obj = parse
    root_obj.global_score
  end

  def solve_part2
    root_obj = parse
    root_obj.garbage_chars.count
  end

  def parse # rubocop:disable Metrics/MethodLength
    stream = input.chars
    i = 0

    current_object = nil
    root_object = nil
    while i < stream.size
      case current_object
      when NilClass, Group
        case stream[i]
        when '{'
          g = Group.new
          if current_object # rubocop:disable Metrics/BlockNesting
            current_object.children << g
            g.parent(current_object)
          end
          root_object ||= g
          current_object = g
        when '}'
          current_object = current_object.parent
        when '<'
          g = Garbage.new
          # garbage cannot be top-level so we assume current_object is not nil
          current_object.children << g
          g.parent(current_object)
          current_object = g
        when ','
          # nothing to be done
        else
          raise "Unexpected char #{stream[i]} at pos #{i} since we are not in a garbage object"
        end
      when Garbage
        case stream[i]
        when '!'
          i += 1 # ignore next object
        when '>'
          current_object = current_object.parent
        else
          current_object << stream[i]
        end
      end
      i += 1
    end
    root_object
  end

  class StreamObject
    def initialize
      @children = []
    end
    attr_reader :children

    def parent(value = nil)
      @parent = value if value
      @parent
    end

    def garbage_chars
      raise NotImplementedError
    end
  end

  class Group < StreamObject
    def score
      if parent
        parent.score + 1
      else
        1
      end
    end

    def global_score
      score + children.filter_map { |child| child.global_score if child.is_a?(Group) }.sum
    end

    def garbage_chars
      children.flat_map(&:garbage_chars)
    end
  end

  class Garbage < StreamObject
    def <<(char)
      @chars ||= []
      @chars << char
    end

    def garbage_chars
      @chars || []
    end
  end
end
