require 'matrix'

MoonAxis = Struct.new(:position, :velocity) do
  def <=>(moon)
    moon.position <=> self.position
  end
end

Moon = Struct.new(:position, :velocity) do
  def initialize(*position)
    super(Vector[*position], Vector[*([0] * position.size)])
  end

  def <=>(moon)
    gravity = [self, moon]
      .map { |m| m.position.to_a }
      .transpose
      .map { |p| p[1] <=> p[0] }

    Vector[*gravity]
  end

  def axis index
    MoonAxis[position[index], velocity[index]]
  end
end

MOONS = [
  Moon[-16, -1, -12],
  Moon[  0, -4, -17],
  Moon[-11, 11,   0],
  Moon[  2,  2,  -6]
]

def gravity moon, other_moon
  gravity = [moon, other_moon]
    .map { |m| m.position.to_a }
    .transpose
    .map { |p| p[1] <=> p[0] }

  Vector[*gravity]
end

def gravity_step moons
  moons.permutation(2).each do |pair|
    pair[0].velocity += pair[0] <=> pair[1]
  end
end

def velocity_step moons
  moons.each { |moon| moon.position += moon.velocity }
end

def energy moon
  kin = moon.velocity.to_a.map(&:abs).sum
  pot = moon.position.to_a.map(&:abs).sum
  kin * pot
end

def total_energy moons
  moons.map { |moon| energy(moon) }.sum
end

def simulate_step moons
  gravity_step moons
  velocity_step moons
end

def simulate moons, steps
  steps.times { simulate_step moons }
  moons
end

def cycle moons
  initial_moons = moons.to_s
  steps = 0

  begin
    steps += 1
    simulate_step moons
  end until initial_moons == moons.to_s

  steps
end

def cycle_axis moons, index
  cycle moons.map { |moon| moon.axis(index)  }
end

def cycle_steps moons
  (0..2).map { |axis| cycle_axis moons, axis }.reduce(:lcm)
end

# Part A
p total_energy(simulate(MOONS.map(&:clone), 1000))

# Part B
p cycle_steps(MOONS.map(&:clone))