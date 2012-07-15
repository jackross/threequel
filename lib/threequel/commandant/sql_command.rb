module Threequel
  module Commandant
    class SQLCommand
      # extend Logging
      # add_logging_to :execute_on

      attr_reader :sql, :name

      def initialize(sql, name = 'Anonymous')
        @sql, @name = sql, name
      end

      def sanitized_sql
        Threequel::SQLUtils.sanitize_sql(@sql)
      end

      def statements
        @statements ||= sanitized_sql.map.with_index{|statement, i| SQLStatement.new(statement, "#{@name}[statement#{i}]", @name)}
      end

      def execute_on(connection)
        puts "-- Starting SQL Execution for: #{@name} at #{Time.now}"
        statements.each{|statement| statement.execute_on connection}
        puts "-- Finishing SQL Execution for: #{@name} at #{Time.now}\n"
      end

      def formatted_sql
        "#{@sql}\nGO\n\n"
      end

    end    

  end
end
