PROGRAM = load_array '2019/input/02'
require_relative 'shared/intcode'

# opcode => count
SMALL_INSTRUCTION_SET = {
  1 => ->(a,b,c) { @program[c] = @program[a] + @program[b] },
  2 => ->(a,b,c) { @program[c] = @program[a] * @program[b] }
}.freeze

def exec noun, verb
  program = Program.new(PROGRAM);
  computer = IntcodeComputer.new(SMALL_INSTRUCTION_SET)
  
  program.restore(noun, verb)
  computer.run(program)

  program[0]
end

def solve_for target
  (0..99).each do |noun|
    (0..99).each do |verb|
      if exec(noun,verb) == target
        return [noun,verb]
      end
    end
  end
end

# Part A
p exec(12,2)

# Part B
p solve_for(19690720)
