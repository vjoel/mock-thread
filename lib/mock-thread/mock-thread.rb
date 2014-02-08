require 'fiber'

require 'mock-thread/mock-queue.rb'

class MockThread
  class IsBlocked < RuntimeError; end
  class IsDone < RuntimeError; end

  def make_queue
    MockQueue.new
  end
  
  # Schedule some code for deferred execution. For example:
  #
  #   c.will {foo}.will {bar}
  #
  # The #foo and #bar methods of c will be called later.
  #
  def will &block
    (@will_do ||= []) << Fiber.new { instance_eval &block }
    self
  end
  
  def step
    loop do
      fiber = @will_do[0] or raise IsDone, "nothing to do"

      if fiber.alive?
        ###update
        val = fiber.resume
        ###update
        return val
      end

      @will_do.shift
    end
  end
  
  def run limit: 100
    loop do
      fiber = @will_do[0] or raise IsDone, "nothing to do"

      count = 0
      while fiber.alive?
        ###update
        val = fiber.resume
        ###update
        if fiber.alive? or @will_do.size > 1
          if val == :block
            count += 1
            if count > limit
              raise IsBlocked, "exceeded blocking limit"
            end
          else
            count = 0
            yield val if block_given?
          end
        else
          return val
        end
      end

      @will_do.shift
    end
  end
  
  def run_until_blocked limit: 100, &block
    begin
      run limit: limit, &block
    rescue IsBlocked
      return
    end
    raise IsDone, "run_until_blocked never blocked"
  end
  
  def now limit: 100, &block
    fiber = Fiber.new { instance_eval &block }
    val = nil
    count = 0
    ###update
    while fiber.alive?
      val = fiber.resume
      if val == :block
        count += 1
        if count > limit
          raise IsBlocked, "cannot now do that -- exceeded blocking limit"
        end
      else
        count = 0
      end
      ###update
    end
    val
  end
end
