class InterruptError < StandardError; end;

RESOLVE= {
  val: {
    0 => ->(operand) { @program[operand] },           # position
    1 => ->(operand) { operand },                     # immediate
  },
  idx: {
    0 => ->(idx) { idx },                             # position
  }
}

INSTRUCTION_SET = {
  1 => ->(a,b,idx) { @program[idx] = a + b },                  # add
  2 => ->(a,b,idx) { @program[idx] = a * b },                  # multiply
  3 => ->(idx) { @program[idx] = @stdin.shift || interrupt },  # set
  4 => ->(a) { @stdout << a },                                 # get
  5 => ->(a,b) { !a.zero? && @iptr = b },                      # jump-if-true
  6 => ->(a,b) { a.zero? && @iptr = b },                       # jump-if-false
  7 => ->(a,b,idx) { @program[idx] = a < b ? 1 : 0 },          # less-than
  8 => ->(a,b,idx) { @program[idx] = a == b ? 1 : 0 },         # equals
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

  def instruction_param_types
    @instruction_param_types ||= INSTRUCTION_SET.map do |op, instruction| 
      [op, instruction.parameters.map { |p| p.last == :idx ? :idx : :val }]
    end.to_h
  end

  def fetch(program)
    modes, op = program.opcode.divmod(100)

    instruction = @instruction_set[op]

    params = program[program.iptr + 1, instruction.arity].each_with_index.map do |param, i|
      type = instruction_param_types[op][i]
      mode = modes.digits[i].to_i || 0
      resolve = RESOLVE[type][mode] 
      program.instance_exec(param, &RESOLVE[type][mode])
    end

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