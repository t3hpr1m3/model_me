require 'spec_helper'

describe ModelMe::AttributeMethods do
  class AttributeModel < ModelMe::Base
    attribute :test, :string
  end

  subject { AttributeModel.new }

  specify { subject.send(:attribute_method?, 'test').should be_true }
  specify { subject.send(:attribute_method?, 'invalid').should be_false }
end
