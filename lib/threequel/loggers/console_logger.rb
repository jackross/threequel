module Threequel
  class ConsoleLogger
    attr_reader :attributes

    def initialize
      @attributes = {}
    end

    def log(stage, logged_attributes)
      @attributes.merge!(logged_attributes)
      puts case stage
        when :started
        when :executing
          "-- Starting execution of #{attributes[:name]} at #{attributes[:started_at]}\n"
        when :finished
          if attributes[:rows_affected]
            "-- Finishing execution of #{attributes[:name]} at #{attributes[:finished_at]} in #{attributes[:duration]} seconds (#{attributes[:rows_affected]} rows affected)"
          else
            "-- Finishing execution of #{attributes[:name]} at #{attributes[:finished_at]} in #{attributes[:duration]} seconds"
          end
        when :error
          "An error occurred"
      end
    end

  end
end
