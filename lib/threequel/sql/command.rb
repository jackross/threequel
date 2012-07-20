module Threequel
  module SQL
    class Command
      SUCCESS = { :message => 'Command executed successfully', :status => :success }

      attr_reader :name

      def initialize(unsanitized_sql, name = 'Anonymous', opts = {})
        @name = name
        @statement_array = SQL::StatementArray.new(unsanitized_sql, name, opts)
        yield self if block_given?
      end
      delegate :sql, :statements, :to => :@statement_array

      def execute_on(connection)
        catch(:failure) do
          statements.each do |statement|
            statement.command_name = @name
            statement.execute_on connection
          end
          SUCCESS
        end
      end

      def attributes
        { :sql => sql, :command => @name, :statement => nil }
      end

    end    

  end
end