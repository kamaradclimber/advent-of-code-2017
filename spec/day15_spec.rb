# frozen_string_literal: true

require 'day15'

RSpec.describe Day15 do
  subject { described_class.new(input: input, part: part) }
  describe 'part 1' do
    let(:part) { 1 }
    {
      'Generator A starts with 65
Generator B starts with 8921' => 588
    }.each do |example, solution|
      context "example #{example[0..15]}" do
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
      'Generator A starts with 65
Generator B starts with 8921' => 309
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
    'Generator A starts with 634
Generator B starts with 301'
  end
end
