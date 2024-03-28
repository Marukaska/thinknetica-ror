fib = []
a = 0
b = 1

while b < 100 do
  fib.push(b)
  a,b = b,a+b
end

puts fib

