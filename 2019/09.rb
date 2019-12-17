BOOST = load_array '2019/input/09'
require_relative 'shared/intcode'

@computer = IntcodeComputer.new

# Part A
p @computer.run(Program.new(BOOST, [1]))

# Part A
p @computer.run(Program.new(BOOST, [2]))
