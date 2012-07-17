module Threequel
  module SQL
    class Fragment < Array

      def self.sanitize(sql)
        self.new(sql).statements
      end

      def initialize(sql)
        @sql = sql
      end

      def statements
        @statments ||= self.tap do |sql|
          sql.split_on_terminator!
          sql.chomp_endings!
          sql.strip_whitespace!
          sql.remove_empty_statements!
        end
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
