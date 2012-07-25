module Threequel
  module SQL
    class CommandHash < Hash
      attr_reader :sql_command_file
      alias :sql_class_methods :keys

      def initialize(sql_command_file, model_name = 'AnonymousModel', opts = {})
        @sql_command_file, @model_name = sql_command_file, model_name
        @opts = opts.reverse_merge(default_opts)
        @loggers = @opts[:loggers]
        setup!
      end

      private
      def setup!
        extracted_code_hash.each do |command, sql|
          self[command.to_sym] = sql_command_for(command, sql)
        end
      end

      def default_opts
        { :loggers => [:db, :console] }
      end

      def code
        @code ||= IO.read(@sql_command_file)
      end

      def extracted_code
        code.scan(/^--#\s:(\w*$)(.*?)^--#/m).flatten
      end

      def extracted_code_hash
        Hash[*extracted_code]
      end

      def command_name_for(command)
        "#{@model_name}.#{command}"
      end

      def sql_command_for(command, sql)
        SQL::Command.new(sql, command_name_for(command), @opts) do |config|
          unless @loggers.empty?
            config.extend(Threequel::Logging)
            config.add_logging_to :execute_on, *@loggers
          end
        end
      end

    end
  end
end