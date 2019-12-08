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
  3 => ->(c) { print ">>"; @program[c] = !@stdin.empty? ? p(@stdin.shift) : STDIN.gets.to_i },
  
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

class Program
  def initialize(program = [99], stdin = [])
    @program = program.clone
    @stdin = stdin
  end

  def iptr
    current_iptr = @iptr
    @iptr = nil
    current_iptr
  end

  def [](*index)
    @program[*index]
  end

  def []= (index, value)
    @program[index] = value
  end

  def restore(noun, verb)
    @program[1] = noun
    @program[2] = verb
  end
end

class IntcodeComputer
  def initialize(instruction_set = INSTRUCTION_SET)
    @instruction_set = instruction_set
  end

  def run(program, debug = false)
    instruction_pointer = 0

    until (opcode = program[instruction_pointer]) == 99
      instruction = @instruction_set[opcode]
      params = program[instruction_pointer + 1, instruction&.arity || 0]
      p "-- #{opcode}(#{params.join(',')})" if debug
      program.instance_exec(*params, &instruction)
      instruction_pointer = program.iptr || instruction_pointer + 1 + params.count
    end

    program
  end
end