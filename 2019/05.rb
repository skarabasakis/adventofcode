PROGRAM = load_array '2019/input/05'
require_relative 'shared/intcode'

def exec
  program = Program.new(PROGRAM);
  computer = IntcodeComputer.new
  
  computer.run(program)
end

# Part A
exec # and type 1

# Part B
exec # and type 5


