module Upsqlert
  module Statement
    extend ActiveSupport::Concern

    module ClassMethods
      UPDATED_FLAG   = "updated_flag"
      INSERTED_FLAG  = "inserted_flag"
      DATE_PROCESSED = "date_processed"

      def table_schema
        table_name.split(".")[0]  
      end

      def unqualified_table_name
        table_name.split(".")[1]  
      end

      def extra_column_names
        [UPDATED_FLAG, INSERTED_FLAG, DATE_PROCESSED]
      end

      def source_column_names
        column_names - extra_column_names
      end

      def destination_column_names
        column_names
      end

      def key_column_names
        sql = <<-SQL
          SELECT
             k.column_name
            ,k.ordinal_position
          FROM information_schema.key_column_usage k
          INNER JOIN information_schema.table_constraints t
            ON t.table_schema    = k.table_schema
           AND t.table_name      = k.table_name 
           AND t.constraint_name = k.constraint_name
          WHERE k.table_schema + '.' + k.table_name = '#{table_name}'
            AND t.constraint_type = 'PRIMARY KEY'
          ORDER BY
             k.ordinal_position
        SQL
        @key_columns ||= find_by_sql(sql).sort(&:ordinal_position).map(&:column_name).map(&:downcase)
      end

      def non_key_column_names
        source_column_names - key_column_names
      end

      def extra_columns_insert_hash
        { UPDATED_FLAG => "0", INSERTED_FLAG => "1", DATE_PROCESSED => "GETDATE()" }
      end

      def extra_columns_update_hash
        { UPDATED_FLAG => "1", INSERTED_FLAG => "0", DATE_PROCESSED => "GETDATE()" }
      end

      def insert_columns_hash
        Hash[destination_column_names.zip(destination_column_names)].merge(extra_columns_insert_hash)
      end

      def update_sql
        <<-"SQL"
          SET
             #{non_key_column_names.map{|col| "t.#{col} = s.#{col}"}.join("\n\t\t,")}
            ,#{extra_columns_update_hash.map{|k, v| "t.#{k} = #{v}"}.join("\n\t\t,")}
        SQL
      end

      def insert_sql
        <<-"SQL"
          (
          \t #{insert_columns_hash.keys.join("\n\t,")}
          )
          VALUES
          (
          \t #{insert_columns_hash.values.join("\n\t,")}
          )
        SQL
      end

      def join_sql
        <<-"SQL"
          ON #{key_column_names.map{|col| "s.#{col} = t.#{col}"}.join("\n AND")}
        SQL
      end

      def using_sql
        "load.#{unqualified_table_name}"
      end

      def merge_sql
        <<-"SQL"
        SET NOCOUNT ON;

        DECLARE @change_summary TABLE(change varchar(20));
        DECLARE @inserts_count int = 0;
        DECLARE @updates_count int = 0;

        MERGE #{table_name} t
        USING #{using_sql} s
        #{join_sql}
        WHEN MATCHED
        THEN UPDATE
        #{update_sql}
        WHEN NOT MATCHED
        THEN INSERT
        #{insert_sql}
        OUTPUT $action INTO @change_summary;

        SELECT
           @inserts_count = SUM(CASE WHEN change = 'Insert' THEN 1 ELSE 0 END)
          ,@updates_count = SUM(CASE WHEN change = 'Update' THEN 1 ELSE 0 END)
        FROM @change_summary;

        EXEC update_table_stats
           @table_name  = 'transactions'
          ,@schema_name = 'data'
          ,@Inserts     = @inserts_count
          ,@Updates     = @updates_count;
        SQL
      end

    end

  end
end