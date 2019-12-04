def load_lines(file, mapper: :to_i)
  open(file).read.split.map(&mapper)
end

def load_array(file, sep: ',', mapper: :to_i)
  open(file).read.split(sep).map(&mapper)
end

def load_matrix(file, sep: ',', mapper: :to_i)
  open(file).read.split.map { |l| l.split(sep).map(&mapper) }
end