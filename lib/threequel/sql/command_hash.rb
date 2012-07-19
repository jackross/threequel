module Threequel
  module SQL
    class CommandHash < Hash
      attr_reader :sql_command_file
      alias :sql_class_methods :keys
      # alias :sql_commands :values

      def initialize(sql_command_file, model_name = 'AnonymousModel', opts = {})
        @sql_command_file, @model_name = sql_command_file, model_name
        default_opts = { :log_to_db => true }
        self.setup!(default_opts.merge(opts))
      end

      def setup!(opts)
        extracted_code_hash.each do |command, sql|
          self[command.to_sym] = sql_command_for(@model_name, command, sql, opts)
        end
      end

      private
      def code
        @code ||= IO.read(@sql_command_file)
      end

      def extracted_code
        code.scan(/^--#\s:(\w*$)(.*?)^--#/m).flatten
      end

      def extracted_code_hash
        Hash[*extracted_code]
      end

      def command_name_for(model_name, command)
        "#{model_name}.#{command}"
      end

      def sql_command_for(model_name, command, sql, opts)
        command_name = command_name_for(model_name, command)
        SQL::Command.new(sql, command_name, opts) do |config|
          config.extend(Threequel::Logging) if opts[:log_to_db]
        end
      end

    end
  end
end