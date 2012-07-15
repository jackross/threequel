module Threequel
  class Timer
    attr_reader :started_at, :finished_at

    def initialize(opts = {})
    end

    def measure(name = "Anonymous Timer")
      begin
        start
        yield
        stop
      rescue Exception => e
        puts "Error while executing '#{name}': '#{e.message}'!"
      ensure
        puts "\n"
      end
    end

    def start
      @started_at = Time.now
    end

    def stop
      @finished_at = Time.now
    end

    def duration
      begin
        @finished_at - @started_at
      rescue
        nil
      end
    end
    
    def attributes
      {:started_at => started_at, :finished_at => finished_at, :duration => duration}
    end

    # private
    # def attribute=(attr, value)
    #   @attributes[attr] = value
    # end

    # def attribute(attr)
    #   @attributes[attr]
    # end

  end
  
end