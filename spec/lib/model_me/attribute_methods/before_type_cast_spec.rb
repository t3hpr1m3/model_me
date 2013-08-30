require 'spec_helper'

describe ModelMe::AttributeMethods::BeforeTypeCast do
  class BeforeTypeCastModel < ModelMe::Base
    attribute :test, :integer
  end

  subject { BeforeTypeCastModel.new(test: '123') }

  its(:test_before_type_cast) { should eql('123') }
  its(:test) { should eql(123) }
end
