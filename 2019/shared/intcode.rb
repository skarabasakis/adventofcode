class Program
  def initialize(program = [99])
    @program = program
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
  def initialize(instruction_set)
    @instruction_set = instruction_set
  end

  def run(program)
    instruction_pointer = 0

    until (opcode = program[instruction_pointer]) == 99
      instruction = @instruction_set[opcode]
      params = program[instruction_pointer + 1, instruction.arity]
      program.instance_exec(*params, &instruction)
      instruction_pointer += 1 + params.count
    end

    program
  end
end