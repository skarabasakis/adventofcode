PROGRAM = load_array '2019/input/05'
require_relative 'shared/intcode'

def exec(input)
  program = Program.new(PROGRAM, input);
  computer = IntcodeComputer.new
  
  computer.run(program)
end

# Part A
p exec([1])

# Part B
p exec([5])


