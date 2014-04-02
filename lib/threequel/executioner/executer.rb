require 'hirb'

module Threequel
  module Executioner
    class Executer

       def self.execute_folder(folder_path)
         self.new(Rails.env).execute_folder folder_path
       end

       def self.execute(file_path)
         self.new(Rails.env).execute file_path
       end

       def initialize(env)
         @client = Connection.new(env).client
       end


       def execute_folder(folder_path, opts = {})
         exceptions = opts.delete(:except)
         (ConfigLoader.new(folder_path).tsorted_scripts - [exceptions].flatten).each do |script|
           execute File.join(folder_path, script)
         end
       end

     end
  end
end
