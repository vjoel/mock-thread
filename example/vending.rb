# Actors are nondeterminstic, so subject to race conditions, so need testing:
#
# This example is based on the one in:
# http://james-iry.blogspot.com/2009/04/erlang-style-actors-are-all-about.html
#
# See also:
# http://pchiusano.blogspot.com/2013/09/actors-are-overly-nondeterminstic.html

require 'mock-thread'

alice   = MockThread.new
bob     = MockThread.new
vendor  = MockThread.new

aq = alice.make_queue
bq = bob.make_queue
vq = vendor.make_queue

3.times do
  alice.will do
    vq << [:coin, aq]
  end
  alice.will do
    puts "alice got #{aq.pop}"
  end
end

3.times do
  bob.will do
    vq << [:coin, bq]
  end
  bob.will do
    puts "bob got #{bq.pop}"
  end
end

vendor.will do
  coins = 0
  loop do
    coin, q = vq.pop
    coins += 1 if coin == :coin
    if coins >= 3
      coins -= 3
      q << :cookie
    end
  end
end

alice.step
bob.step
alice.step
vendor.run_until_blocked
bob.step
bob.step
alice.step
bob.step
