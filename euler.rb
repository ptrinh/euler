class Fixnum
  def is_palindrome?
    s = self.to_s
    r = s.reverse
    s == r
  end

  def is_prime?
    MillerRabin.is_prime? self
  end
end

class MillerRabin
  def MillerRabin.calc_d_and_s d, s=0
    if 0 == d % 2
      calc_d_and_s(d/2, s+1) 
    else
      [d, s]
    end
  end

  def MillerRabin.congruent_mod l, r, n
    (l % n) == (r % n);
  end

  def MillerRabin.is_prime? n
    a_values = [2,3,5,7,11,13,17]

    return false if n == 1
    return true if a_values.include? n
    return false if a_values.any? {|a| 0 == n%a } 

    puts "Warning, '#{n}' is greater than the deterministic limit for this algorithm" if n >= 341550071728321
    d, s = *calc_d_and_s(n-1)

    max_a = [n-1, (2*(Math.log(n)**2)).floor].min
    a_values.select { |a| a <= max_a }.each do |a|
      first_check = !(congruent_mod a**d, 1, n)

      second_check = (0..(s-1)).all? do |r|
        !(congruent_mod((a**((2**r)*d)), (n-1), n))
      end
      return false if first_check && second_check
    end

    return true
  end
end

class SieveOfAtkin
  #TODO: split loops and optimize given that (x+1)**2 = x**2 + (2*x + 1)
  #TODO: replace is_prime array with bit field
  def SieveOfAtkin.primes_upto limit

    #is_prime = [false] * (limit + 1)
    is_prime = BitField.new(limit+1)

    sqrt_limit = Math.sqrt(limit).floor

    xx = 0 
    (1..sqrt_limit).each do |x|
      xx += (x + x - 1)
      yy = 0
      (1..sqrt_limit).each do |y|
        yy += (y + y -1)

        n = 4*xx + yy #4x^2 + y^2
        is_prime[n] = !(is_prime[n]) if (n <= limit) and ([1,5].include?(n%12)) 

        n = n - xx #3x^2 + y^2
        is_prime[n] = !(is_prime[n]) if (n <= limit) and (7 == n % 12) 

        n = n - yy - yy #3x^2 - y^2
        is_prime[n] = !(is_prime[n]) if (x > y) and (n <= limit) and (11 == n % 12) 
      end
    end

    (5..sqrt_limit).each do |n|
      if is_prime[n] then
        nn = n * n
        k = nn
        while k <= limit
          is_prime[k] = false
          k = k + nn
        end
      end
    end

    primes = [2, 3]
    (5..limit).each do |n|
      primes << n if is_prime[n]
    end

    primes
  end
end

class BitField
  def initialize size
    @size = size
    @bits_per_integer = 30
    ints_required = (@size / @bits_per_integer) + 1 # + 1 not needed if 0 == size % integer_size
    @ints = [0] * ints_required
  end

  def location n
    index = n / @bits_per_integer
    offset = n % @bits_per_integer
    [index, offset]
  end

  def [] n
    raise "BORKED" if n >= @size
    index, offset = *location(n)
    (@ints[index] & (1 << offset)) > 0
  end

  def []= n, val
    index, offset = *location(n)
    if val
      @ints[index] = (@ints[index] | 2**offset)
    else
      all_ones = 2**(@bits_per_integer) - 1
      mask = 1 << offset
      not_mask = all_ones - mask
      @ints[index] = (@ints[index] & not_mask)
    end
  end

  def BitField.test 
    size = 1025
    b = BitField.new(size)
    (0...size).each do |x|
      raise "Not False x: #{x}" if b[x]
      b[x] = true
      (0...size).each do |y|
        raise "Not False x: #{x}, y:#{y}" if b[y] && x!=y
      end
      b[x] = false
    end
    :pass
  end

end

class Factorize
  def Factorize.trial_divide n, primes_hint = nil
    primes = (primes_hint.nil?) ? SieveOfAtkin.primes_upto(Math.sqrt(n).floor) : primes_hint
    factors = {} 
    primes.each do |p|
      while (n >= p) && (0 == n % p)
        factors[p] ||= 0
        factors[p] += 1
        n = n / p
      end
    end    
    raise "Failed to fully factorize. Provide a larger primes hint" if n > 1
    factors
  end
end
