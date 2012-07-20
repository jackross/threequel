module Threequel
  class Logger

    def initialize(opts = {})
      @opts          = opts.reverse_merge(default_opts)
      @print_output  = @opts[:print_output]
      @log_to_db     = @opts[:log_to_db]
      @timer         = Threequel::Timer.new
      @rows_affected = -1
    end
    delegate :started_at, :finished_at, :duration, :state, :clock, :to => :@timer
    delegate :attributes, :to => :@timer, :prefix => true

    def log(name, log_data = {})
      log_entry = Threequel::LogEntry.new(log_data.merge(:name => name))
      result = clock(name) do
        print_output_for name
        log_to_db_with log_entry
        yield
      end
      log_to_db_with log_entry, result
      print_output_for name
    end

    private
    def default_opts
      { :log_to_db => true, :print_output => true }
    end

    def print_output_for(name)
      puts case state
        when :executing
          "-- Starting execution of #{name} at #{started_at}\n"
        when :finished
          "-- Finishing execution of #{name} at #{finished_at} in #{duration} seconds"
      end if @print_output
    end

    def log_to_db_with(log_entry, result = {})
      log_entry.log_execution_for(state, timer_attributes.merge(result)) if @log_to_db
    end
  end
end
