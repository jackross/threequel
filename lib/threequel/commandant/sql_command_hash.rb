module Threequel
  module Commandant
    class SQLCommandHash < Hash
      attr_reader :sql_command_file
      alias :sql_class_methods :keys
      # alias :sql_commands :values

      def initialize(sql_command_file, model_name = 'Anonymous')
        @sql_command_file = sql_command_file
        Hash[*(code.scan(/^--#\s:(\w*$)(.*?)^--#/m).flatten)].each do |command, sql|
          self[command.to_sym] = SQLCommand.new(sql, "#{model_name}.#{command}", :log_to_db => true)
        end
      end

      def code
        @code ||= IO.read(@sql_command_file)
      end

    end
  end
end