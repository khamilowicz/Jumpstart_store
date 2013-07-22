require "thread"

queue = Queue.new

producer = Thred.new do
	5.times do
		value = sleep(rand(3))
		queue << value
		puts "Producer #{value}"
	end
end


consumer = Thred.new do
	5.times do
		value = queue.pop
		sleep(rand(3))
		puts "Producer #{value}"
	end
end

consumer.join
