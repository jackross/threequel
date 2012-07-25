# based on the name of the class that the module is included within
# read a file in a conventional/specified location
# regex the file
# load the regex results into a hash
# for each key in the match, execute a define_method on the class using the hash key's value


module Threequel
  module Commandant
    extend ActiveSupport::Concern

    included do
      define_sql_commands_as_class_methods
    end

    module ClassMethods
      delegate :sql_class_methods, :to => :sql_command_hash

      def commandant_loggers
        @commandant_loggers || default_commandant_loggers
      end

      def commandant_loggers=(loggers)
        @commandant_loggers = [loggers].flatten
      end

      def default_commandant_loggers
        [:db, :console]
      end

      def sql_command_file_path
        @sql_command_file_path || default_sql_command_file_path
      end

      def sql_command_file_path=(path)
        @sql_command_file_path = path
      end

      def default_sql_command_file_path
        File.join(Rails.root, "db", "models", "#{self.name.underscore}.sql") # i.e. db/models/membership.sql
      end

      def sql_command_hash
        @sql_command_hash ||= SQL::CommandHash.new(sql_command_file_path, self.name, { :loggers => commandant_loggers })
      end

      def sql_command_for(method)
        sql_command_hash[method]
      end

      def sql_for(method)
        sql_command_for(method).sql
      end

      def execute_sql_command(method)
        sql_command_for(method).execute_on(connection)
      end

      def define_sql_class_method_for(method)
        define_singleton_method(method) do
          execute_sql_command(method)
        end
      end

      def define_sql_commands_as_class_methods
        sql_class_methods.each do |command_name|
          define_sql_class_method_for(command_name)
        end
      end

    end
  end
end
