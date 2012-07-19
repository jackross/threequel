module Threequel
  module SQL
    module Utils

      def self.sanitized_sql(unsanitized_sql)
        Threequel::SQL::StatementArray.new(unsanitized_sql).sql
      end

    end
  end
end
