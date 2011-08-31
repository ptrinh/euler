require 'euler'

palindromes = []
999.downto(100) do |x|
  999.downto(100) do |y|
    z = x * y
    palindromes << z if z.is_palindrome?
  end
end

puts palindromes.sort.last
