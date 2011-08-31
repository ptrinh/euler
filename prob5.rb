#smallest number divisible by each of [1,20]

prime_factors = {
  2 => [2],
  3 => [3],
  4 => [2,2],
  5 => [5],
  6 => [2,3],
  7 => [7],
  8 => [2,2,2],
  9 => [2,3],
  10 => [2,5],
  11 => [11],
  12 => [2,2,3],
  13 => [13],
  14 => [2,7],
  15 => [3,5],
  16 => [2,2,2,2],
  17 => [17],
  18 => [2,3,3],
  19 => [19],
  20 => [2,2,5],
}

unique_factors = prime_factors.values.flatten.uniq
unique_factor_max_occurances = {}

prime_factors.values.each do |factors|
  unique_factors.each do |factor|
    factor_count = factors.select {|f| f==factor}.size
    unique_factor_max_occurances[factor] = factor_count if (unique_factor_max_occurances[factor].nil?) || factor_count > unique_factor_max_occurances[factor]
  end
end

unique_factor_max_occurances.each { |kvp| puts "#{kvp.first} => #{kvp.last}" }
puts unique_factor_max_occurances.inject(1) { |prod, kvp| (prod * (kvp.first**kvp.last)) }
