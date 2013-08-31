require 'spec_helper'

describe ModelMe::Serialization do
  class SerializationModel < ModelMe::Base
    attribute :test1, :integer
    attribute :test2, :string
    attribute :test3, :date
  end

  subject { SerializationModel.new(test1: 321, test2: 'foo', test3: '1/1/2001') }
  it { should respond_to(:to_json) }
  it { should respond_to(:as_json) }
  it { should respond_to(:serializable_hash) }
  its(:to_json) { should eql("{\"test1\":321,\"test2\":\"foo\",\"test3\":\"2001-01-01\"}") }
end
