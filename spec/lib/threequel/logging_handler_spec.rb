require_relative '../../spec_helper'

describe Threequel::LoggingHandler do

  describe "handling logging" do
    subject { Threequel::LoggingHandler.new }

    let(:loggers)          { { :loggers => [:db, :console] } }
    let(:name)             { "logging test" }
    let(:initial_log_data) { { :foo => "foo", :bar => "bar" } }
    let(:result)           { { :result => 42 } }
    let(:timer_attributes) { { :att1 => :val1, :att2 => :val2 } }

    it "interacts appropriately with a Logger class" do
      logger = MiniTest::Mock.new

      logger.expect :new, logger
      logger.expect :log, nil, [:executing, initial_log_data.merge(:name => name).merge(timer_attributes)]
      logger.expect :log, nil, [:finished, timer_attributes.merge(result)]

      subject.stub :timer_attributes, timer_attributes do
        subject.register_logger logger
        subject.handle_logging(name, initial_log_data){ result }
      end

      logger.verify
    end

    it "creates and updates an accurate log entry" do
      expected = {
        :started_state  => :executing,
        :finished_state => :finished,
        :result         => result[:result]
      }
      
      logger = Class.new do
        attr_reader :attributes

        def initialize()
          @attributes = {}
        end

        def log(stage, data_to_be_logged)
          case stage
          when :executing
            @attributes[:started_state]  = stage
          when :finished
            @attributes[:finished_state] = stage
            @attributes[:result]         = data_to_be_logged[:result]
          end
          @attributes
        end
      end

      subject.register_logger logger
      subject.handle_logging(name, initial_log_data){ result }[0].attributes.must_equal expected

    end
  end

end
