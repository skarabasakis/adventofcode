RANGE = 254032..789860

def digits_of number
  number.digits.reverse
end

def adjacent? digits
  digits.each_cons(2).map { |a, b| a == b }.any?
end

def strict_adjacent? digits
  [-1, *digits, -1].each_cons(4).map do |a, b, c, d| 
    a != b && b == c && c != d
  end.any?
end

def ascending? digits
  digits.each_cons(2).map { |a, b| a <= b }.all?
end

def password? digits
  adjacent?(digits) && ascending?(digits)
end

def strict_password? digits
  strict_adjacent?(digits) && ascending?(digits)
end

# Part A
p RANGE.count { |n| password?(digits_of(n)) }

# Part B
p RANGE.count { |n| strict_password?(digits_of(n)) }