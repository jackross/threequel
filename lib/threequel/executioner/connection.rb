module Threequel
  module Executioner
    class Connection
      def initialize(env)
       @connection_properties = ActiveRecord::Base.configurations[env].select do |k, v| 
         %w(username password host port database).include?(k)
       end.with_indifferent_access.merge(:timeout => 0)
      end

      def client
        puts @connection_properties
        @client ||= TinyTds::Client.new @connection_properties
      end
    end
  end
end

