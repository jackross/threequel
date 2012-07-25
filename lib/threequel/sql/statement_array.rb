module Threequel
  module SQL
    class StatementArray < Array

      def initialize(unsanitized_sql, name = 'Anonymous SQL Block', opts = {})
        @unsanitized_sql, @name = unsanitized_sql, name
        @opts                   = opts.reverse_merge(default_opts)
        @statement_terminator   = @opts[:statement_terminator]
        @loggers                = @opts[:loggers] || []
        setup!
      end

      def statements
        @statements ||= self.map.with_index do |statement, i|
          SQL::Statement.new(statement, "#{@name}[statement#{i}]", @opts) do |config|
            unless @loggers.empty?
              config.extend(Threequel::Logging)
              config.add_logging_to :execute_on, *@loggers
            end
          end
        end
      end

      def sql
        self.clone.push("").join("#{@statement_terminator}\n\n")
      end
      
      def inspect
        statements
      end

      private
      def default_opts
        { :statement_terminator => Threequel::STATEMENT_TERMINATOR }
      end

      def split_on_terminator!
        @unsanitized_sql.split(@statement_terminator).each.with_index{|s, i| self[i] = s}
      end

      def strip_whitespace!
        self.each(&:strip!)
      end

      def remove_empty_statements!
        self.delete_if(&:empty?).delete_if(&:nil?)
      end

      def setup!
        split_on_terminator!
        strip_whitespace!
        remove_empty_statements!
      end

    end
  end
end
