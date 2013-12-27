require 'pi_piper'
include PiPiper


pin = PiPiper::Pin.new(:pin => 18, :direction => :in)
pin = PiPiper::Pin.new(:pin => 23, :direction => :in)

pin = PiPiper::Pin.new(:pin => 24, :direction => :in)
pin = PiPiper::Pin.new(:pin => 25, :direction => :in)

pin = PiPiper::Pin.new(:pin => 8, :direction => :in)
pin = PiPiper::Pin.new(:pin => 7, :direction => :in)

watch :pin => 18 do
  puts "Pin 18 changed from #{last_value} to #{value}"
end

watch :pin => 23 do
  puts "Pin 23 changed from #{last_value} to #{value}"
end

watch :pin => 24 do
  puts "Pin 24 changed from #{last_value} to #{value}"
end

watch :pin => 25 do
  puts "Pin 25 changed from #{last_value} to #{value}"
end


watch :pin => 8 do
  puts "Pin 8 changed from #{last_value} to #{value}"
end

watch :pin => 7 do
  puts "Pin 7 changed from #{last_value} to #{value}"
end

PiPiper.wait
