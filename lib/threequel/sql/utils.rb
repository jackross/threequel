module Threequel
  module SQL
    module Utils

      def self.sanitize_sql(sql)
        Threequel::SQL::Fragment.sanitize(sql)
      end

    end
  end
end
