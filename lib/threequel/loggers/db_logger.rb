module Threequel
  class DBLogger
    STORAGE_KLASS = Threequel::DBLoggerStorage

    def initialize()
      @log_entry = STORAGE_KLASS.new
    end

    def log(stage, data_to_be_logged)
      @log_entry.log_execution_for(stage, data_to_be_logged)
    end

  end
end
