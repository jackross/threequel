require 'hirb'
require "executioner/script"
require "executioner/sorter"
require "executioner/config_loader"

module Threequel
  class Executioner
    def self.execute_folder(folder_path)
      self.new(Rails.env).execute_folder folder_path
    end

    def self.execute(file_path)
      self.new(Rails.env).execute file_path
    end

    def connection
      ActiveRecord::Base.connection
    end

    def initialize(env)
     @client = Connection.new(env).client
    end

    def execute(path)
      script = Script.new(path)

      command = SQL::Command.new(script.code, path, {}) do |config|
        config.extend(Threequel::Logging)
        config.add_logging_to :execute_on, :db, :console
      end

      command.execute_on(connection)
    end

    def execute_folder(folder_path, opts = {})
      exceptions = opts.delete(:except)
      (ConfigLoader.new(folder_path).tsorted_scripts - [exceptions].flatten).each do |script|
        execute File.join(folder_path, script)
      end
    end
  end
end
