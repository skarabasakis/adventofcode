INPUT = load_lines '2019/input/01'

def fuel(mass)
  [0, (mass / 3.0).floor - 2].max
end

def total_fuel(mass)
  fuels = [fuel(mass)]
  while ((next_fuel = fuel(fuels.last)) > 0)
    fuels << next_fuel
  end

  fuels.sum
end

# Part A
p INPUT.map { |mass| fuel(mass) }.sum

# Part B
p INPUT.map { |mass| total_fuel(mass) }.sum