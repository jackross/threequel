module Threequel
  module SQL
    class Statement
      SUCCESS = { :message => 'Statement executed successfully', :status => :success }

      attr_reader :sql, :name, :rows_affected
      attr_accessor :command_name

      def initialize(sql, name, command_name = nil, opts = {})
        @sql, @name, @command_name = sql, name, command_name
        @opts = opts.reverse_merge(default_opts)
        yield self if block_given?
      end

      def execute_on(connection)
        begin
          @rows_affected = connection.send(:do_execute, @sql)
          # puts "execute_on for #{@name}"; @rows_affected = 23
          SUCCESS.merge(:rows_affected => @rows_affected)
        rescue => ex
          message = "Error while executing '#{@name}': '#{ex.message}'!"
          throw :failure, { :message => message, :status => :failure }
        end
      end

      def formatted_sql
        "#{@sql}#{@opts[:statement_terminator]}\n"
      end

      def attributes
        {:sql => formatted_sql, :command => @command_name, :statement => @name}
      end

      private
      def default_opts
        { :statement_terminator => Threequel::STATEMENT_TERMINATOR }
      end

    end    
  end
end
