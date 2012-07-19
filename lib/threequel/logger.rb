module Threequel
  class Logger
    attr_reader :timer

    def initialize(opts = {})
      @print_output  = opts.delete(:print_output)
      @timer         = Threequel::Timer.new
      @rows_affected = -1
    end
    delegate :started_at, :finished_at, :duration, :to => :timer

    def log(name, log_data = {})
      log_entry = Threequel::LogEntry.new(log_data.merge(:name => name))
      timer.measure(name) do
        begin
          puts "-- Starting execution of #{name} at #{started_at}\n"
          log_entry.log_execution_for("Executing", timer.attributes)
          @rows_affected = yield
        rescue => ex
          puts "Error while executing '#{name}': '#{ex.message}'!"
        end
      end
      log_entry.log_execution_for("Finished", timer.attributes.merge(:rows_affected => @rows_affected))
      puts "-- Finishing execution of #{name} at #{finished_at} in #{duration} seconds"
    end
  end
end
