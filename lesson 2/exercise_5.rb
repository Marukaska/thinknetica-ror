puts "Введите год, месяц, день (в числовом формате,через пробел):"
get_data = gets.chomp.split(" ")
year = get_data[0].to_i
month = get_data[1].to_i
day = get_data[2].to_i

months = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
leap_year = (year % 4).zero? && ((year % 10) !=0 || (year % 400).zero?)
months[1] = 29 if leap_year

month_control = 0
day_count = 0
months.each do |days|
  if month_control < month-1
    day_count += days
    month_control +=1
  end
end

puts "Указанная дата имеет #{day_count + day} порядковый номер в году"