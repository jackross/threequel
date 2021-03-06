module Threequel
  module SQL
    class StatementArray < Array

      def initialize(unsanitized_sql, name = 'Anonymous SQL Block', opts = {})
        @unsanitized_sql, @name = unsanitized_sql, name
        @opts                   = opts.reverse_merge(default_opts)
        @statement_terminator   = @opts[:statement_terminator]
        @statement_splitter     = @opts[:statement_splitter]
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
        { :statement_terminator => Threequel::STATEMENT_TERMINATOR, :statement_splitter => /^(.*?)^\s*GO|^(.*?)\z/im }
      end

      def split_on_terminator!
        @unsanitized_sql.scan(@statement_splitter).flatten.each.with_index{|s, i| self[i] = s}
      end

      def remove_nil_statements!
        self.delete_if(&:nil?)
      end

      def strip_whitespace!
        self.each(&:strip!)
      end

      def remove_empty_statements!
        self.delete_if(&:empty?)
      end

      def strip_multiline_comments!
        regexp = /\/\*[^*]*\*+(?:[^*\/][^*]*\*+)*\//
        @unsanitized_sql.gsub!(regexp, '')
      end

      def strip_single_line_comments!
        @unsanitized_sql.gsub!(/--.*$/, '')
      end

      def strip_comments!
        strip_multiline_comments!
        strip_single_line_comments!
      end

      def setup!
        strip_comments!
        split_on_terminator!
        remove_nil_statements!
        strip_whitespace!
        remove_empty_statements!
      end

    end
  end
end
