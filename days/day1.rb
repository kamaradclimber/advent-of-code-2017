# frozen_string_literal: true

require 'aoc'

class Day1
  def initialize(part2: false)
    @part2 = part2
  end

  def to_s
    self.class.name + (part2? ? ' part2' : '')
  end

  def part2?
    @part2
  end

  def captcha(input)
    if part2?
      captcha_part2(input)
    else
      captcha_part1(input)
    end
  end

  def captcha_part1(input)
    chars = input.to_s.chars
    chars << chars.first
    chars.each_cons(2).filter_map do |el, next_el|
      el.to_i if el == next_el
    end.sum
  end

  def captcha_part2(input)
    chars = input.to_s.chars
    ahead = chars.size / 2

    chars.each_with_index.filter_map do |el, index|
      el.to_i if el == chars[(index + ahead) % chars.size]
    end.sum
  end
end
