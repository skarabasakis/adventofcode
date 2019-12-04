# frozen_string_literal: true
PROGRAM = load_array '2019/input/02'

# opcode => count
PARAM_COUNT = {
  1 => 3,
  2 => 3,
  99 => 0
}.freeze

$program = nil

def restore(noun, verb)
  $program[1] = noun
  $program[2] = verb
end

def run_command(opcode, parameters)
  case opcode
  when 1
    op1 = $program[parameters[0]]
    op2 = $program[parameters[1]]
    $program[parameters[2]] = op1 + op2
  when 2
    op1 = $program[parameters[0]]
    op2 = $program[parameters[1]]
    $program[parameters[2]] = op1 * op2
  end
end

def run
  iptr = 0

  begin
    opcode = $program[iptr]
    parameters = $program[iptr + 1...iptr + 1 + PARAM_COUNT[opcode]]
    iptr += 1 + PARAM_COUNT[opcode]
    run_command opcode, parameters
  end until opcode == 99

  return $program[0]
end

def exec noun, verb
  $program = PROGRAM.clone;
  restore noun, verb
  run
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
