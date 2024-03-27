puts "Привет, как тебя зовут?"
name_id = gets.chomp
puts "Давай расчитаем твой идеальный вес, укажите свой рост:"
height_id = gets.chomp
weight_id = (height_id.to_i - 110) * 1.15

if weight_id < 0
	puts "Ваш вес уже оптимальный"
else
	puts "Твой идеальный вес #{weight_id}"
end