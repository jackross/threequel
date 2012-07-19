module Threequel
  module SQL
    class Statement

      attr_reader :sql, :name, :rows_affected
      attr_accessor :command_name

      def initialize(sql, name, command_name = nil, opts = {})
        @sql, @name, @command_name = sql, name, command_name
        yield self if block_given?
      end

      def execute_on(connection)
        rows_affected = begin
          connection.send(:do_execute, @sql)
          # puts "execute_on for #{@name}"; 23
        rescue => ex
          nil.tap do |r|
            puts "Error while executing '#{@name}': '#{ex.message}'!"
          end
        end
      end

      def formatted_sql
        "#{@sql}\nGO\n"
      end

      def attributes
        {:sql => formatted_sql, :command => @command_name, :statement => @name}
      end

    end    
  end
end
