puts "Укажите значение a:"
a = gets.chomp.to_i
puts "Укажите значение b:"
b = gets.chomp.to_i
puts "УУкажите значение c:"
c = gets.chomp.to_i

d = b**2 - 4*a*c

if d < 0
  puts "Корней нет"
elsif d == 0
  puts "Дискриминант = #{d}, один корень, X = #{-b / 2 * a}"
elsif d > 0
  d_sqrt = Math.sqrt(d)
  puts "Дискриминант = #{d}, X1 = #{(-b + d_sqrt)/ 2 * a}, X2 = #{(-b - d_sqrt) / 2 * a}"
end
