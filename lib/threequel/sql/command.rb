module Threequel
  module SQL
    class Command

      attr_reader :name, :statement_array

      def initialize(unsanitized_sql, name = 'Anonymous', opts = {})
        @name = name
        @statement_array = SQL::StatementArray.new(unsanitized_sql, name, opts)
        yield self if block_given?
      end
      delegate :sql, :statements, :to => :statement_array

      def execute_on(connection)
        statements.each do |statement|
          statement.command_name = @name
          statement.execute_on connection
        end
      end

      def attributes
        { :sql => sql, :command => @name, :statement => nil }
      end

    end    

  end
end
