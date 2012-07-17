require_relative '../../test_helper'

describe Threequel::Timer do

  subject { Threequel::Timer.new }

  describe "measuring time" do
    
    it "must be able to start" do
      subject.must_respond_to(:start)
    end

    it "must return an instance of Time when it starts" do
      subject.start.must_be_instance_of(Time)
    end

    it "must be able to stop" do
      subject.must_respond_to(:stop)
    end

    it "must return an instance of Time when it stops" do
      subject.stop.must_be_instance_of(Time)
    end

  end

end