module Threequel
  module SQLUtils

    def self.sanitize_sql(sql)
      sql.split("\nGO").map(&:chomp).map(&:strip).reject(&:empty?).compact
    end

  end
end
