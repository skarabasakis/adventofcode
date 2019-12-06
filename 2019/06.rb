ORBITS = load_matrix '2019/input/06', sep: ')', mapper: :to_s

TRANSFERS_BACKWARDS = ORBITS.map(&:reverse).to_h
TRANSFERS_FORWARDS = ORBITS.each_with_object({}) do |orbit, transfers| 
  (transfers[orbit[0]] ||= []) << orbit[1]
end

def orbit_chain body
  chain = [body]
  chain << TRANSFERS_BACKWARDS[chain.last] until chain.last == 'COM'
  
  chain[1..-1]
end

# Part A
BODIES = TRANSFERS_BACKWARDS.keys
p BODIES.map { |body| orbit_chain(body).count }.reduce(&:+)

# Part B
# TODO Implement Dijksta's algorithm to find shortest path
p TRANSFERS_FORWARDS