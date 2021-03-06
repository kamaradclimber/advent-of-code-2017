# frozen_string_literal: true

require 'day13'

RSpec.describe Day13::Scanner do
  subject { Day13::Scanner.new(depth: 0, range: range) }

  context 'range is 3' do
    let(:range) { 3 }
    {
      '0': 0, '1': 1, '2': 2, '3': 1,
      '4': 0, '5': 1, '6': 2, '7': 1,
      '8': 0, '9': 1, '10': 2, '11': 1,
      '12': 0, '13': 1, '14': 2, '15': 1
    }.each do |tick, pos|
      it 'computes positions correctly' do
        expect(subject.position(tick.to_s.to_i)).to eq(pos)
      end
    end
  end
  context 'range is 4' do
    let(:range) { 4 }
    {
      '0': 0, '1': 1, '2': 2, '3': 3, '4': 2, '5': 1,
      '6': 0, '7': 1, '8': 2, '9': 3, '10': 2, '11': 1
    }.each do |tick, pos|
      it 'computes positions correctly' do
        expect(subject.position(tick.to_s.to_i)).to eq(pos)
      end
    end
  end
end

RSpec.describe Day13 do
  subject { described_class.new(input: input, part: part) }
  describe 'part 1' do
    let(:part) { 1 }
    {
      '0: 3
1: 2
4: 4
6: 4' => 24
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
      '0: 3
1: 2
4: 4
6: 4' => 10
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
    %(0: 3
1: 2
2: 4
4: 4
6: 5
8: 6
10: 6
12: 8
14: 6
16: 6
18: 9
20: 8
22: 8
24: 8
26: 12
28: 8
30: 12
32: 12
34: 12
36: 10
38: 14
40: 12
42: 10
44: 8
46: 12
48: 14
50: 12
52: 14
54: 14
56: 14
58: 12
62: 14
64: 12
66: 12
68: 14
70: 14
72: 14
74: 17
76: 14
78: 18
84: 14
90: 20
92: 14)
  end
end
