module Threequel
  module Commandant
    module Logging
      extend ActiveSupport::Concern

      included do
        extend ActiveModel::Callbacks
        define_model_callbacks :execute
        around_execute :log
      end

      def log
        Threequel::Logger.new(:print_output => true).log(@name, log_data) do
          yield
        end
      end

    end
  end
end

      # def add_logging_to(*args)
      #   @logged_methods ||= []
      #   @logged_methods.concat(args)
      # end
   
      # def method_added(method_name)
      #   if @logged_methods.include?(method_name)
      #     unless @added
      #       @added = true
      #       stashed_method = "stashed_#{method_name}".to_sym
      #       alias_method stashed_method, method_name
      #       define_method method_name do |*args|
      #         Threequel::Logger.new(:print_output => true).log(@name, log_data) do
      #           # log_klass = class_eval("#{self.class.name}LogEntry")
      #           # log_entry = log_klass.create({:status => "Executing", :name => @name, :command => @command, :sql => @sql, :created_at => start_time})
      #           # puts "-- Starting execution of #{@name} at #{start_time}\n"
      #           print formatted_sql
      #           rows_affected = send(stashed_method, *args)
      #           # log_entry.update_attributes(:status => "Finished", :rows_affected => rows_affected, :updated_at => finish_time, :duration => duration)
      #           # puts "-- Finishing execution of #{@name} at #{finish_time}"
      #         end
      #       end
      #     end
      #     @added = false
      #   end
      # end
