module Threequel
  module Commandant
    class SQLStatement
      include Logging

      attr_reader :sql, :command, :name, :row_affected

      def initialize(sql, name, command)
        @sql, @name, @command = sql, name, command
      end

      def execute_on(connection)
        run_callbacks :execute do
          begin
            # connection.send(:do_execute, @sql)
            puts "execute_on for #{@name}"
            23
          rescue Exception => e
            puts "Error while executing '#{@name}': '#{e.message}'!"
          end
        end
      end

      def formatted_sql
        "#{@sql}\nGO\n\n"
      end

      def log_data
        {:sql => @sql, :command => @command}
      end

    end    
  end
end
