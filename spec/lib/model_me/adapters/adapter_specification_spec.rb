require 'spec_helper'

describe ModelMe::Adapters::AdapterSpecification do
  subject { ModelMe::Adapters::AdapterSpecification.new('dev', adapter: 'dummy', value: 'test') }
  it { should respond_to(:name) }
  it { should respond_to(:adapter) }
  it { should respond_to(:config) }

  it 'should raise an exception if the adapter is not specified' do
    lambda { ModelMe::Adapters::AdapterSpecification.new('dev', {foo: 'bar'}) }.should raise_error(ModelMe::InvalidSpecification)
  end

  describe 'config' do
    it 'should respond to string keys' do
      subject.config['value'].should eql('test')
    end

    it 'should respond to symbol keys' do
      subject.config[:value].should eql('test')
    end
  end
end
