L1, L2 = load_matrix '2019/input/03', mapper: :to_s

def point(direction, d, x, y)
  case direction
  when 'R'
    [x + d, y]
  when 'L'
    [x - d, y]
  when 'U'
    [x, y + d]
  when 'D'
    [x, y - d]
  end
end

def segment_points(start, direction, length)
  (1..length).map { |dist| point(direction, dist, *start) }
end

def line_points(line)
  p = [];

  start = [0,0]
  while (segment = line.shift)
    direction, length = segment[0], segment[1..-1].to_i
    points = segment_points(start, direction, length)
    start = points.last
    p += points
  end

  p
end

def common_points(lines)
  lpoints = lines.map { |line| line_points(line) }
  cpoints = lpoints.reduce(&:&);

  cpoints.map do |p|
    [p, lpoints.map { |line| line.find_index(p) + 1 }.reduce(&:+)]
  end.to_h
end

def manhattan(point)
  point.map(&:abs).reduce(&:+)
end

$common_points = common_points([L1, L2])

# Part A
p $common_points.keys.map { |p| manhattan(p) }.min

# Part B
p $common_points.min_by { |p,v| v }[1]
