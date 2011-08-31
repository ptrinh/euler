require 'euler'

=begin
#Naive Approach
#use some type of primality check to check each
#number until you find 10001 primes

primes = [2]
x = 3
while primes.size < 10001
  if x.is_prime?
    primes << x
    puts primes.size
  end
  x += 2
end
primes.each_with_index { |p, i| puts "#{i+1}: #{p}" }
=end



#Smarter approach
#get an upper bound on the 10001st prime
#then sieve upto that bound 

def prime_bounds n
  n_ln_n = n * Math.log(n)
  n_ln_ln_n = n * Math.log(Math.log(n))

  lower = n_ln_n + n_ln_ln_n - n
  upper = n_ln_n + n_ln_ln_n

  [lower, upper]
end

upper_bound = prime_bounds(10001).last.ceil
puts SieveOfAtkin.primes_upto(upper_bound)[10000]
