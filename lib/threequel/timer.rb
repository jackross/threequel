module Threequel
  class Timer
    attr_reader :started_at, :finished_at, :state

    def initialize(opts = {})
      @state = :initialized
    end

    def clock(name = "Anonymous Timer")
      begin
        start
        result = yield
        stop
      rescue => ex
        @state = :error
        puts "Error while executing '#{name}': '#{ex.message}'!"
      end
      result
    end

    def start
      @finished_at = nil
      @started_at = Time.now
      @state = :executing
    end

    def stop
      @finished_at = Time.now
      @state = :finished
    end

    def duration
      begin
        @finished_at - @started_at
      rescue
        nil
      end
    end
    
    def attributes
      { :started_at => started_at, :finished_at => finished_at, :duration => duration }
    end

  end
  
end