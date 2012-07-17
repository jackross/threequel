module Threequel
  module SQL
    class Fragment < Array

      def self.sanitize(sql)
        self.new(sql).statements
      end

      def initialize(sql)
        @sql = sql
        sanitize!
      end

      def sanitize!
        split_on_terminator!
        chomp_endings!
        strip_whitespace!
        remove_empty_statements!
      end

      def statements
        self
      end
      
      def split_on_terminator!
        @sql.split(Threequel::STATEMENT_TERMINATOR).each.with_index{|s, i| self[i] = s}
      end

      def chomp_endings!
        self.each(&:chomp!)
      end

      def strip_whitespace!
        self.each(&:strip!)
      end

      def remove_empty_statements!
        self.reject(&:empty?).compact
      end

      def inspect
        statements
      end
    end
  end
end
