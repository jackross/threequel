module Threequel
  class CheetahMailLogger
    STORAGE_KLASS = Threequel::DBLoggerStorage

    def initialize()
      @log_entry = STORAGE_KLASS.new
      @data_to_be_logged = {}
    end

    def log(stage, data_to_be_logged)
      @data_to_be_logged = data_to_be_logged
      set_cheetah_mail_defaults
      @log_entry.log_execution_for(stage, data_to_be_logged)
    end

    def set_cheetah_mail_defaults
      @data_to_be_logged[:command] ||= @data_to_be_logged[:state]
      @data_to_be_logged[:sql]     ||= "SQL Statement For #{@data_to_be_logged[:name]} to #{@data_to_be_logged[:state]}"
    end
  end
end
