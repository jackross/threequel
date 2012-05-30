# require_relative "threequel/commandant/command_hash"
require "threequel/commandant/command_hash"

module Threequel
  module Commandant
    module ClassMethods
      def sql_command_file_path
        File.join(Rails.root, "db", "sql", "#{self.name.tableize}.sql")
        # '/Users/jackross/Dropbox/Code/usga/usga/db/sql/refreshers/facts.memberships.sql'
      end

      def command_hash
        @command_hash ||= CommandHash.new(sql_command_file_path)
      end

      def commands
        command_hash.commands
      end

      def define_sql_class_method(method, sql)
        self.class.send(:define_method, method) do
          method_label = "#{self.name}.#{method}"
          timer = Timer.new(:title => "Commandant")
          timer.time("Finished running #{method_label}!") do
            # puts "Started SQL for #{class_label} at #{Time.now}"
            print sql
            connection.execute sql
            # puts "Finished SQL for #{class_label} at #{Time.now}"
            sleep 3
          end
        end
      end

      def append_sql_commands_as_class_methods
        command_hash.each do |command, sql|
          define_sql_class_method command, sql
        end
      end

    end
    
    module InstanceMethods
      
    end
    
    def self.included(receiver)
      puts "Included #{receiver}"
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.append_sql_commands_as_class_methods
    end
  end
end

# filename = './db/sql/refreshers/facts.mems.sql'
# code = IO.read(filename)
# sql_commands = Hash[*(code.scan(/^--#\s:(\w*$)(.*?)^--#/m).flatten)]

# in the future, allow for templating

# based on the name of the class that the module is included within
  # read a file in a conventional/specified location
  # regex the file
  # load the regex results into a hash
  # for each key in the match, execute a define_method on the class using the hash key's value

