module Threequel
  module SQL
    class StatementArray < Array

      def initialize(unsanitized_sql, name = 'Anonymous SQL Block', opts = {})
        @unsanitized_sql, @name, @opts = unsanitized_sql, name, opts
        self.sanitize!
      end

      def sanitize!
        split_on_terminator!
        chomp_endings!
        strip_whitespace!
        remove_empty_statements!
      end

      def statements
        @statements ||= self.map.with_index do |statement, i|
          SQL::Statement.new(statement, "#{@name}[statement#{i}]", @opts) do |config|
            config.extend(Threequel::Logging) if @opts[:log_to_db]
          end
        end
      end

      def sql
        self.clone.push("").join("#{Threequel::STATEMENT_TERMINATOR}\n\n")
      end
      
      def split_on_terminator!
        @unsanitized_sql.split(Threequel::STATEMENT_TERMINATOR).each.with_index{|s, i| self[i] = s}
      end

      def chomp_endings!
        self.each(&:chomp!)
      end

      def strip_whitespace!
        self.each(&:strip!)
      end

      def remove_empty_statements!
        self.reject!(&:empty?).compact!
      end

      def inspect
        statements
      end
    end
  end
end
