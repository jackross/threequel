# require_relative "threequel/commandant/command_hash"
module Threequel
  module Commandant
    extend ActiveSupport::Concern

    included do
      define_sql_commands_as_class_methods
    end

    module ClassMethods
      delegate :sql_class_methods, :to => :sql_command_hash

      def sql_command_file_path
        File.join(Rails.root, "db", "models", "#{self.name.underscore}.sql") # i.e. db/models/membership.sql
      end

      def sql_command_hash
        @sql_command_hash ||= SQLCommandHash.new(sql_command_file_path, self.name)
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

# based on the name of the class that the module is included within
  # read a file in a conventional/specified location
  # regex the file
  # load the regex results into a hash
  # for each key in the match, execute a define_method on the class using the hash key's value

