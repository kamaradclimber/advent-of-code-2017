# frozen_string_literal: true

require 'day3'

RSpec.describe Day3 do
  subject { described_class.new(input: input, part: part) }
  describe 'part 1' do
    let(:part) { 1 }
    {
      1 => 0,
      12 => 3,
      23 => 2,
      1024 => 31
    }.each do |example, solution|
      context "example #{example[0..15]}" do
        let(:input) { example }
        it "works on example #{example}" do
          expect(subject.solve).to eq(solution)
        end
      end
    end

    it 'computes corner_values correctly' do
      expect(subject.se(1)).to eq(9)
      expect(subject.ne(1)).to eq(3)
      expect(subject.se(2)).to eq(25)
      expect(subject.ne(2)).to eq(13)
      expect(subject.nw(2)).to eq(17)
      expect(subject.sw(2)).to eq(21)
      expect(subject.ne(3)).to eq(31)
    end

    it 'computes coords correctly' do
      expect(subject.coords(1)).to eq([0, 0])
      expect(subject.coords(9)).to eq([1, -1])
      expect(subject.coords(10)).to eq([2, -1])
      expect(subject.coords(11)).to eq([2, 0])
      expect(subject.coords(12)).to eq([2, 1])
      expect(subject.coords(13)).to eq([2, 2])
      expect(subject.coords(14)).to eq([1, 2])
      expect(subject.coords(15)).to eq([0, 2])
      expect(subject.coords(17)).to eq([-2, 2])
      expect(subject.coords(20)).to eq([-2, -1])
      expect(subject.coords(23)).to eq([0, -2])
      expect(subject.coords(28)).to eq([3, 0])
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
    }.each do |example, solution|
      context "example #{example[0..15]}" do
        let(:input) { example }
        pending "works on example #{example}" do
          expect(subject.solve).to eq(solution)
        end
      end
    end

    context 'real input' do
      pending 'finds a solution for part2' do
        solution = subject.solve
        puts "Solution for part 2 is #{solution}"
      end
    end
  end

  let(:input) do
    312051
  end
end
