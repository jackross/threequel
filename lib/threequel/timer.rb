module Threequel
  class Timer
    attr_reader :started_at, :finished_at, :state
 
    def initialize(opts = {})
      @state = :initialized
    end

    def clock(name = "Anonymous Timer")
      begin
        start
        @state = :executing
        result = yield
        stop
      rescue => ex
        @state = :error
        raise TimerException.new("Error while executing '#{name}': '#{ex.message}'!")
      end
      result
    end

    def start
      @finished_at = nil
      @state = :started
      @started_at = Time.now
    end

    def stop
      @state = :finished
      @finished_at = Time.now
    end

    def finish
      stop
    end

    def duration
      begin
        @finished_at - @started_at
      rescue
        nil
      end
    end
    
    def attributes
      { :started_at => started_at, :finished_at => finished_at, :duration => duration, :state => state }
    end

    def inspect
      attributes
    end

    def to_s
      attributes
    end

    class TimerException < Exception
    end

  end
  
end