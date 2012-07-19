module Threequel
  class LogEntry < ActiveRecord::Base
    self.table_name_prefix = "threequel."

    def self.construct
      ActiveRecord::Migration.class_eval do
        create_table Threequel::LogEntry.table_name do |t|
          t.string   :status,        :null => false, :limit => 20
          t.string   :name,          :null => false, :limit => 128
          t.string   :command,       :null => false, :limit => 128
          t.string   :statement,     :null => true,  :limit => 128
          t.text     :sql,           :null => false
          t.integer  :rows_affected, :null => true
          t.float    :duration,      :null => true
          t.datetime :started_at,    :null => false
          t.datetime :finished_at,   :null => true
        end
      end
    end

    def self.drop
      ActiveRecord::Migration.class_eval do
        drop_table Threequel::LogEntry.table_name
      end
    end

    def log_execution_for(status, data)
      self.update_attributes data.merge(:status => status)
    end

  end
end
