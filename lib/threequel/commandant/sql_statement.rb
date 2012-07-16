module Threequel
  module Commandant
    class SQLStatement

      # extend ActiveModel::Callbacks

      attr_reader :sql, :command, :name, :rows_affected

      def initialize(sql, name, command)
        @sql, @name, @command = sql, name, command
      end

      def execute_on(connection)
        rows_affected = begin
          connection.send(:do_execute, @sql)
          # puts "execute_on for #{@name}"
          # 23
        rescue => ex
          nil.tap do |r|
            puts "Error while executing '#{@name}': '#{ex.message}'!"
          end
        end
      end

      def formatted_sql
        "#{@sql}\nGO\n\n"
      end

      def attributes
        {:sql => @sql, :command => @command}
      end

    end    
  end
end
