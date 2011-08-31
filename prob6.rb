def sum_of_squares n
  (n*(n+1)*(n+n+1))/6
end

def sum_upto n
  ((n**2) + n)/2
end

def square_of_sum n
  sum_upto(n)**2
end

n = ARGV[0].to_i
x = square_of_sum(n)
y = sum_of_squares(n)
puts "x:#{x}, y:#{y}"
puts (square_of_sum(n) - sum_of_squares(n))
