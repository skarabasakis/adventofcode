PIXELS = load_array '2019/input/08', sep: ''
WIDTH, HEIGHT = [25,6]

def digit_counts(layer, digits)
  digits.map { |d| [d, layer.count(d)] }.to_h
end

def checksum_layer(layers)
  layers.each_with_index
    .map { |layer, i| [i, digit_counts(layer, 0..2)] }
    .sort_by { |counts| counts[1][0] }
    .first
end

def layers
  PIXELS.each_slice(WIDTH*HEIGHT).to_a
end

def mask(image, layer)
  (0...WIDTH*HEIGHT)
    .map { |i| image[i] == 2 ? layer[i] : image[i] }
end

def decode(layers)
  layers.reduce { |image, layer| mask(image, layer) }
end

def display(image)
  image.map { |p| p.zero? ? '█': ' '}
    .each_slice(WIDTH).map { |line| line.join }
    .each { |line| puts line }
end

# Part A
i, c = checksum_layer(layers)
p c[1] * c[2]

# Part B
display(decode(layers))


