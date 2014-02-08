require 'minitest/autorun'

require 'mock-thread/mock-thread.rb'

class TestMockThread < Minitest::Test
  def test_step
    mt = MockThread.new
    
    mt.will do
      3.times do |i|
        Fiber.yield i
      end
      "done"
    end

    assert_equal 0, mt.step
    assert_equal 1, mt.step
    assert_equal 2, mt.step
    assert_equal "done", mt.step
    assert_raises MockThread::IsDone do
      mt.step
    end
  end
  
  def test_run
    mt = MockThread.new
    
    mt.will do
      3.times do |i|
        Fiber.yield i
      end
      "done"
    end
    
    a = []
    r = mt.run do |val|
      a << val
    end
    
    assert_equal "done", r
    assert_equal [0,1,2], a
  end
  
  def test_run_until_blocked
    mt = MockThread.new
    
    mt.will do
      3.times do |i|
        Fiber.yield i
      end
      11.times do
        Fiber.yield :block
      end
      "done"
    end
    
    a = []
    mt.run_until_blocked limit:10 do |val|
      a << val
    end
    
    assert_equal [0,1,2], a

    r = mt.run
    assert_equal "done", r
  end

  def test_now
    mt = MockThread.new
    
    result = mt.now do
      3.times do
        Fiber.yield :block
      end
      "done"
    end
    
    assert_equal "done", result
  end
  
  def test_now_limit
    mt = MockThread.new
    
    assert_raises MockThread::IsBlocked do
      mt.now limit: 2 do
        3.times do
          Fiber.yield :block
        end
        "done"
      end
    end
  end
end
