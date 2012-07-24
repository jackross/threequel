require_relative '../../spec_helper'

describe Threequel::Logger do

  describe "logging" do
    let(:opts) { { :log_to_db => true, :print_output => true } }
    subject { Threequel::Logger.new(opts) }

    let(:name)     { "logging test" }
    let(:log_data) { { :foo => "foo", :bar => "bar" } }
    let(:result)   { { :result => 42 } }

    it "calls new on log_entry" do
      log_entry_klass = MiniTest::Mock.new
      log_entry_klass.expect :new, nil, [log_data.merge(:name => name)]

      subject.stub :log_to_db_with, nil do
        subject.log(name, log_data, log_entry_klass) do
          result
        end
      end

      log_entry_klass.verify
    end

    it "creates and updates an accurate log entry" do
      expected = {
        :started_state  => :executing,
        :finished_state => :finished,
        :result         => result[:result]
      }
      
      log_entry_klass = Class.new do
        attr_reader :attributes

        def initialize(log_data = {})
          @attributes = {}
        end

        def log_execution_for(state, log_data)
          case state
          when :executing
            @attributes[:started_state]  = state
          when :finished
            @attributes[:finished_state] = state
            @attributes[:result]         = log_data[:result]
          end
          @attributes
        end
      end

      subject.log(name, log_data, log_entry_klass) do
        result
      end.must_equal expected

    end
  end

end
