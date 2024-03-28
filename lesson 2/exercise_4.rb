abc = ("a".."z").to_a

vowels = {}
number_latter = 1

abc.each do |leter|
  if 'aeiou'.include?(leter)
    vowels[leter] = number_latter
    number_latter += 1
  else
    number_latter += 1
  end
end

puts(vowels)
