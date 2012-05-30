module Threequel
  module Commandant
    class CommandHash < Hash
      alias :commands :keys
      alias :sql :values

      def initialize(sql_command_file)
        puts "Loading #{sql_command_file}"
        @sql_command_file = sql_command_file
        Hash[*(code.scan(/^--#\s:(\w*$)(.*?)^--#/m).flatten)].each{|k, v| self[k.to_sym] = v}
      end

      def code
        @code ||= IO.read(@sql_command_file)
      end

    end
  end
end