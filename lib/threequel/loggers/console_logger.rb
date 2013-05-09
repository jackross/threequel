module Threequel
  class ConsoleLogger
    attr_reader :attributes

    def initialize
      @attributes = {}
    end

    def log(stage, logged_attributes)
      @attributes.merge!(logged_attributes)
      puts case stage
        when :executing
          "-- Starting execution of #{attributes[:name]} at #{attributes[:started_at]}\n"
        when :finished
          "-- Finishing execution of #{attributes[:name]} at #{attributes[:finished_at]} in #{attributes[:duration]} seconds (#{attributes[:rows_affected]} rows affected)"
      end
    end

  end
end
