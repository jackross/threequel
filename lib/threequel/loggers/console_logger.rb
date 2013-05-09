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
          "-- Starting execution of #{attributes[:name]} on #{started_at}\n"
        when :finished
          if attributes[:rows_affected]
            "-- Finishing execution of #{attributes[:name]} on #{finished_at} in #{duration} (#{attributes[:rows_affected]} rows affected)"
          else
            "-- Finishing execution of #{attributes[:name]} on #{finished_at} in #{duration}"
          end
        when :error
          "An error occurred"
      end
    end

    private
    def started_at
      I18n.l attributes[:started_at], :format => :console_logger
    end

    def finished_at
      I18n.l attributes[:finished_at], :format => :console_logger
    end

    def duration_minutes
      (attributes[:duration].to_f / 60).floor
    end

    def duration_seconds
      (attributes[:duration].to_f % 60).ceil
    end

    def duration_minutes_words
      duration_minutes > 0 ? "#{duration_minutes} #{'minute'.pluralize(duration_minutes)}" : nil
    end

    def duration_seconds_words
      duration_seconds > 0 ? "#{duration_seconds} #{'second'.pluralize(duration_seconds)}" : nil
    end

    def duration
      [duration_minutes_words, duration_seconds_words].compact.join(" and ")
    end
  end
end
