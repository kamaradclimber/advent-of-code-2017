# frozen_string_literal: true

require 'day10'

RSpec.describe Day10 do
  subject { described_class.new(input: input, part: part) }
  describe 'part 1' do
    let(:part) { 1 }
    {
      '3, 4, 1, 5' => 12
    }.each do |example, solution|
      context "example #{example[0..15]}" do
        subject do
          described_class.new(input: input, part: part, circular_list_size: 5)
        end
        let(:input) { example }
        it "works on example #{example}" do
          expect(subject.solve).to eq(solution)
        end
      end
    end

    context 'real input' do
      it 'finds a solution for part1' do
        solution = subject.solve
        puts "Solution for part 1 is #{solution}"
      end
    end
  end

  describe 'part 2' do
    let(:part) { 2 }
    {
      '' => 'a2582a3a0e66e6e86e3812dcb672a272',
      'AoC 2017' => '33efeb34ea91902bb2f59c9920caa6cd',
      '1,2,3' => '3efbe78a8d82f29979031a4aa0b16a9d',
      '1,2,4' => '63960835bcdc130f0b66d7ff4f6a5a8e'
    }.each do |example, solution|
      context "example #{example[0..15]}" do
        let(:input) { example }
        it "works on example #{example}" do
          expect(subject.solve).to eq(solution)
        end
      end
    end

    context 'real input' do
      it 'finds a solution for part2' do
        solution = subject.solve
        puts "Solution for part 2 is #{solution}"
      end
    end
  end

  let(:input) do
    '165,1,255,31,87,52,24,113,0,91,148,254,158,2,73,153'
  end
end
