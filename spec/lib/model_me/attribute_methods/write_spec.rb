require 'spec_helper'

describe ModelMe::AttributeMethods::Write do
  class WriteModel < ModelMe::Base
    attribute :test, :string
  end

  subject { WriteModel.new }

  describe 'assign_attributes' do
    it 'should raise UnknownAttributeError when an invalid attribute name is passed' do
      lambda { subject.assign_attributes(invalid: 'foo') }.should raise_error(ModelMe::UnknownAttributeError)
    end
  end

  describe 'write_attribute' do
    it 'should raise UnknownAttributeError when an invalid attribute name is passed' do
      lambda { subject.write_attribute(:invalid, 'foo') }.should raise_error(ModelMe::UnknownAttributeError)
    end
  end
end
