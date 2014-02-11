require 'mock-thread/mock-thread'

mt1 = MockThread.new
q1 = mt1.make_queue

mt2 = MockThread.new
q2 = mt2.make_queue

mt1.will do
  x = q1.pop
  x += ", seen by mt1"
  q2.push x
end

mt2.will do
  x = q2.pop
  x += ", seen by mt2"
  puts x
end

q1.push "some data"

mt1.run
mt2.run
