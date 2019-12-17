ASTEROIDS = load_matrix '2019/input/10', sep: '', mapper: :to_s

WIDTH = ASTEROIDS.first.size
HEIGHT = ASTEROIDS.size

require 'matrix'

def points
  @points ||= (0...HEIGHT).map { |y| (0...WIDTH).map { |x| [x,y] } }.flatten(1)
end

def asteroid? point
  ASTEROIDS[point[1]][point[0]] == '#'
end

def asteroids
  @asteroids ||= points.select { |p| asteroid?(p) }
end

def points_inbetween station, point
  station, point = Vector[*station], Vector[*point]

  points_count = (station - point).reduce(:gcd)
  return [] if points_count == 0

  points_step = (station - point) / points_count
  (1..points_count).map { |c| (station - c * points_step).to_a }
end

def visible? station, point
  inbetween = points_inbetween(station, point) - [point]
  inbetween.none? { |p| asteroid?(p) }
end

def visible_asteroids station
  (asteroids - [station])
    .select { |asteroid| visible?(station, asteroid) }
end

def visible_count station
  visible_asteroids(station).count
end

def asteroid_position station, point
  (points_inbetween(station, point) & asteroids).count
end

def angle station, point
  station, point = Vector[*station], Vector[*point]
  angle = Vector[0,-1].angle_with(point - station)

  if point[0] - station[0] >= 0
    angle
  else
    2 * Math::PI - angle
  end
end

def vaporization_order station, asteroid
  [asteroid_position(station, asteroid), angle(station, asteroid)]
end

def asteroid_id(asteroid)
  asteroid[0] * 100 + asteroid[1]
end

# Part A
station = asteroids.sort_by { |station| visible_count(station) }.last
p visible_count(station)

# Part B
vaporized_asteroids = asteroids - [station]
vaporized_asteroids_in_order = vaporized_asteroids.sort_by { |asteroid| vaporization_order(station, asteroid)  }
p asteroid_id(vaporized_asteroids_in_order[199])
