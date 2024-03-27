puts "Привет, давай узнаем какой твой треугольник. Укажи длину стороны a:"
a = gets.chomp.to_i
puts "Укажи длину стороны b:"
b = gets.chomp.to_i
puts "Укажи длину стороны c:"
c = gets.chomp.to_i

if a >b && a > c
  max_side = a
  side_one = b
  side_two = c
elsif b > a && b > c
  max_side = b
  side_one = a
  side_two = c
else
  max_side = c
  side_one = b
  side_two = a
end

puts (side_one ** 2) + (side_two ** 2)

if (a == b) || (b == c) || (c == a)
  puts "Твой треугольник равнобедренный"
elsif a == b && b == c
  puts "Твой треугольник равнобедренный и равносторонний"
elsif (side_one ** 2) + (side_two ** 2) == max_side ** 2
  puts "Твой треугольник прямоугольный"
else
  puts "Твой треугольник какой неправльный, попробуй еще"
end

