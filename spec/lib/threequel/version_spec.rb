require_relative '../../spec_helper'

describe Threequel do
  it "must be defined" do
    Threequel::VERSION.wont_be_nil
  end
end