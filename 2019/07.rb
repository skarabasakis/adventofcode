PROGRAM = load_array '2019/input/07'
require_relative 'shared/intcode'

@computer = IntcodeComputer.new

def phases(range)
  range.to_a.permutation.to_a
end

def amplifiers(phases)
  phases.map { |phase| Program.new(PROGRAM, [phase]) }
end

# Part A
p phases(0..4).map { |p| @computer.run_pipe(amplifiers(p), 0) }.max

# Part B
p phases(5..9).map { |p| @computer.run_loop(amplifiers(p), 0) }.max