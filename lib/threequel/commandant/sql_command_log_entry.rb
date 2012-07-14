module Threequel
  module Commandant
    class SQLCommandLogEntry < ActiveRecord::Base
      self.table_name_prefix = "threequel."

      def self.construct
        ActiveRecord::Migration.class_eval do
          create_table SQLCommandLogEntry.table_name, :force => true do |t|
            t.string  :status,   :null => false, :limit => 20
            t.string  :name,     :null => false, :limit => 128
            t.text    :sql,      :null => false
            t.float   :duration, :null => true
            t.timestamps
          end
        end
      end

      def self.drop
        ActiveRecord::Migration.class_eval do
          drop_table SQLCommandLogEntry.table_name
        end
      end
    end
  end
end
