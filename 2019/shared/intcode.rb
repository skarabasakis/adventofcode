class InterruptError < StandardError; end;

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
  3 => ->(c) { @program[c] = @stdin.shift || interrupt },
  
  # get
    4 => ->(c) { @stdout << @program[c] },
  104 => ->(c) { @stdout << c },

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
  TERMINATION_OPCODE = 99

  def initialize(program = [TERMINATION_OPCODE], stdin = [])
    @iptr = 0
    @next = nil
    @program = program.clone
    @stdin = stdin
    @stdout = []
  end

  def interrupt
    @iptr -= 2
    raise InterruptError.new 
  end

  def blocked?
    @program[@iptr] == 3 && @stdin.empty?
  end

  def terminated?
    @program[@iptr] == TERMINATION_OPCODE
  end

  def opcode
    @program[@iptr]
  end

  def iptr=(value)
    @iptr = value
  end

  def iptr
    @iptr
  end

  def output
    @stdout.last
  end

  def flush
    @stdout.shift(@stdout.size)
  end
  
  def <<(value)
    @stdin.push(*value)
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

  def fetch(program)
    instruction = @instruction_set[program.opcode]
    raise "Invalid instruction: #{program.opcode}" if instruction.nil?
    params = program[program.iptr + 1, instruction.arity]
    program.iptr += 1 + instruction.arity
    [instruction, params] 
  end

  def execute(program, instruction, params)
    program.instance_exec(*params, &instruction)
  end

  def run(program)
    begin
      until program.terminated?
        execute(program, *fetch(program))
      end
    rescue InterruptError
      return program.flush
    end

    program.output
  end

  def run_pipe(programs, input = nil)
    output = input

    programs.each do |program|
      program << output
      output = run(program)
    end

    output
  end

  def run_loop(programs, input = nil)
    output = input

    until programs.all? { |p| p.terminated? }
      programs.each_with_index do |program, i|
        program << output
        raise "Deadlock!" if program.blocked?
        output = run(program)
      end
    end

    output
  end
end