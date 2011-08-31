limit = 1000000

$lengths = {}
def collatz_length n
  length = -1
  cached = $lengths[n]
  if !(cached.nil?)
    length = cached
  elsif n <= 1
    length = 1
  elsif 0 == n % 2
    length = collatz_length(n/2) + 1
  else
    length = collatz_length(3*n + 1) + 1
  end

  $lengths[n] = length
  length
end

(1..limit).each do |n|
  length = collatz_length(n)
  puts "#{n}: #{length}"
end

sorted = $lengths.select { |k,v| v <= limit }.sort { |a,b| a[1] <=> b[1] }
puts sorted.last

