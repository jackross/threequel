module Threequel
  module SQLUtils
    extend self

    def sanitize_sql(sql)
      sql.split("\nGO").map(&:chomp).map(&:strip).reject!(&:empty?).compact
    end

  end
end
