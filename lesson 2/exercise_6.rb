shopping_cart = Hash.new

loop do
  puts "Введите наименование, цену и количество товара(через пробел):"
  product = gets.chomp.split(" ")
  break if product[0] == "stop"
  product_name = product[0]
  product_price = product[1].to_i
  product_count = product[2].to_i
  if shopping_cart[product_name.to_sym].nil?
    shopping_cart[product_name.to_sym] = {product_price => product_count}
  else
    puts "Товар уже добавлен в корзину"
  end
end
sum = 0
puts "В вайшей корзине:"
shopping_cart.each do |key, value|
  value.each do |price, count|
    sum += price*count
    puts "#Наименование: #{key} цена: #{price} количество: #{count} общая сумма: #{price*count}"
  end
end
puts "Общая сумма покупок: #{sum}"

