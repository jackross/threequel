module Threequel
  module Commandant
    module Logging

      def add_logging_to(*args)
        @logged_methods ||= []
        @logged_methods.concat(args)
      end
   
      def method_added(method_name)
        if @logged_methods.include?(method_name)
          unless @added
            @added = true
            stashed_method = "stashed_#{method_name}".to_sym
            alias_method stashed_method, method_name
            define_method method_name do |*args|
              begin
                start_time = Time.now
                log_klass = class_eval("#{self.class.name}LogEntry")
                log_entry = log_klass.create({:status => "Executing", :name => name, :sql => sql, :created_at => start_time})
                puts "-- Starting execution of #{@name} at #{start_time}\n"
                print formatted_sql
                send(stashed_method, args)
                finish_time = Time.now
                duration = finish_time - start_time
                log_entry.update_attributes(:status => "Finished", :updated_at => finish_time, :duration => duration)
                puts "-- Finishing execution of #{@name} at #{finish_time}"
              rescue Exception => e
                puts "Error while executing '#{@name}': '#{e.message}'!"
              ensure
                puts "\n"
              end
            end
          end
          @added = false
        end
      end

    end
  end
end