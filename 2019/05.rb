PROGRAM = load_array '2019/input/05'
require_relative 'shared/intcode'

# opcode => count
INSTRUCTION_SET = {
  # add
     1 => ->(a,b,c) { @program[c] = @program[a] + @program[b] },
   101 => ->(a,b,c) { @program[c] = a + @program[b] },
  1001 => ->(a,b,c) { @program[c] = @program[a] + b },
  1101 => ->(a,b,c) { @program[c] = a + b },

  # multiply
     2 => ->(a,b,c) { @program[c] = @program[a] * @program[b] },
   102 => ->(a,b,c) { @program[c] = a * @program[b] },
  1002 => ->(a,b,c) { @program[c] = @program[a] * b },
  1102 => ->(a,b,c) { @program[c] = a * b },

  # set
  3 => ->(c) { print ">>"; @program[c] = STDIN.gets.to_i },
  
  # get
    4 => ->(c) { p @program[c] },
  104 => ->(c) { p c },

  # jump-if-true
     5 => ->(a,b) { !@program[a].zero? && @iptr = @program[b] },
   105 => ->(a,b) { !a.zero? && @iptr = @program[b] },
  1005 => ->(a,b) { !@program[a].zero? && @iptr = b },
  1105 => ->(a,b) { !a.zero? && @iptr = b },

  # jump-if-false
     6 => ->(a,b) { @program[a].zero? && @iptr = @program[b] },
   106 => ->(a,b) { a.zero? && @iptr = @program[b] },
  1006 => ->(a,b) { @program[a].zero? && @iptr = b },
  1106 => ->(a,b) { a.zero? && @iptr = b },

  # less-than
     7 => ->(a,b,c) { @program[c] = @program[a] < @program[b] ? 1 : 0 },
   107 => ->(a,b,c) { @program[c] = a < @program[b] ? 1 : 0 },
  1007 => ->(a,b,c) { @program[c] = @program[a] < b ? 1 : 0 },
  1107 => ->(a,b,c) { @program[c] = a < b ? 1 : 0 },

  # equals
     8 => ->(a,b,c) { @program[c] = @program[a] == @program[b] ? 1 : 0 },
   108 => ->(a,b,c) { @program[c] = a == @program[b] ? 1 : 0 },
  1008 => ->(a,b,c) { @program[c] = @program[a] == b ? 1 : 0 },
  1108 => ->(a,b,c) { @program[c] = a == b ? 1 : 0 },
}.freeze

def exec
  program = Program.new(PROGRAM.clone);
  computer = IntcodeComputer.new(INSTRUCTION_SET)
  
  computer.run(program)
end

# Part A
exec # and type 1

# Part B
exec # and type 5


