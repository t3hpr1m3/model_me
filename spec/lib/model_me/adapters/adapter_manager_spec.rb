require 'spec_helper'

describe ModelMe::Adapters::AdapterManager do
  describe 'class' do
    subject { ModelMe::Adapters::AdapterManager }
    it { should respond_to(:registered) }
    it { should respond_to(:registered?) }
    it { should respond_to(:register) }

    it 'should remember registered adapters' do
      subject.stub(registered: {dummy: double()})
      subject.registered?(:dummy).should be_true
    end
  end

  it { should respond_to(:adapter_pools) }
  it { should respond_to(:create_adapter) }
  it { should respond_to(:retrieve_adapter) }

  let(:manager) { ModelMe::Adapters::AdapterManager.new }
  subject { manager }

  describe 'creating an adapter' do
    it 'should add the adapter to the pool' do
      manager.create_adapter('TestModel', ModelMe::Adapters::AdapterSpecification.new(:dev, {adapter: 'dummy'}))

    end
  end
end
