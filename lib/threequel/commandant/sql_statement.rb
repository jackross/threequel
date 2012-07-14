module Threequel
  module Commandant
    class SQLStatement
      extend Logging
      add_logging_to :execute_on

      attr_reader :sql, :name

      def initialize(sql, name)
        @sql, @name = sql, name
      end

      def execute_on(connection)
        # connection.send(:do_execute, @sql)
        puts "execute_on for #{@name}"
      end

      def formatted_sql
        "#{@sql}\nGO\n\n"
      end

    end    
  end
end
