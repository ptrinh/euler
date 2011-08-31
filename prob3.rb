def find_largest_prime_factor n
  (2...n).each do |d|
    puts "n: #{n}; d: #{d}" if 0 == (n % d)
    return find_largest_prime_factor(n/d) if 0 == (n % d )
  end
  n
end


puts find_largest_prime_factor(ARGV[0].to_i)
