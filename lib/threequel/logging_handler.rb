module Threequel
  class LoggingHandler

    def initialize(timer_klass = Clockblock::Timer)
      @timer          = timer_klass.new
      @logger_klasses = []
      yield self if block_given?
    end
    delegate :started_at, :finished_at, :duration, :stage, :clock, :to => :@timer
    delegate :attributes, :to => :@timer, :prefix => :timer

    def register_logger(klass)
      @logger_klasses << klass
    end

    def ensure_logger
      register_logger Threequel::ConsoleLogger if @logger_klasses.empty?
    end

    def handle_logging(name, initial_log_data = {})
      ensure_logger
      loggers = @logger_klasses.map(&:new)
      result = clock(name) do
        loggers.each{ |logger| logger.log stage, initial_log_data.merge(:name => name).merge(timer_attributes) }
        yield
      end
      loggers.each{ |logger| logger.log stage, initial_log_data.merge(timer_attributes).merge(result) }

      raise result[:message] if result[:status] == :failure

      result
    end

  end
end
