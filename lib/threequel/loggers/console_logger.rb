module Threequel
  class ConsoleLogger

    def log(stage, attributes)
      puts case stage
        when :executing
          "-- Starting execution of #{attributes[:name]} at #{attributes[:started_at]}\n"
        when :finished
          "-- Finishing execution of #{attributes[:name]} at #{attributes[:finished_at]} in #{attributes[:duration]} seconds"
      end
    end

  end
end
