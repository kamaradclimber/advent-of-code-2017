# frozen_string_literal: true

class KnotHash
  def initialize(input:, circular_list_size: 256)
    @input = input
    @circular_list_size = circular_list_size
    @list = (0..circular_list_size - 1).to_a
    @current_position = 0
    @skip_size = 0
  end
  attr_reader :list

  def compute_hash
    suffix = [17, 31, 73, 47, 23]
    lengthes = @input.strip.chars.map(&:ord) + suffix
    64.times do
      round(lengthes)
      raise 'Assertion false: size is not the same' unless @circular_list_size == @list.size
    end
    dense_hash
  end

  def round(lengthes)
    lengthes.each do |length|
      apply(length)
    end
  end

  def apply(length)
    reverse(@current_position, length)
    @current_position = index(@current_position + length + @skip_size)
    @skip_size += 1
  end

  def inspect
    "#{@list.join(',')}\npos: #{@current_position} skip: #{@skip_size}"
  end

  def reverse(start, length)
    (length / 2).times do |i|
      a_index = index(start + i)
      b_index = index(start + length - 1 - i)
      a = @list[a_index]
      b = @list[b_index]
      @list[a_index] = b
      @list[b_index] = a
    end
  end

  # return an index within the list
  def index(i)
    if i < @list.size
      i
    else
      (i % @list.size)
    end
  end

  def dense_hash
    hexes = @list.each_slice(16).map do |slice|
      slice.reduce do |memo, el|
        memo ^ el
      end
    end
    hexes.map { |int| format('%02x', int) }.join # rubocop:disable Style/FormatStringToken
  end
end
