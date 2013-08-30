require 'spec_helper'

describe ModelMe::Base do
  subject { ModelMe::Base }
  it { should respond_to(:configure) }
  it { should respond_to(:specs) }
  it { should respond_to(:add_spec) }

  describe 'configure' do
    it 'should yield ModelMe::Base class' do
      expect { |b| ModelMe::Base.configure(&b) }.to yield_with_args(ModelMe::Base)
    end
  end

  describe 'add_spec' do
    it 'should add to the hash of specs' do
      ModelMe::Base.add_spec(:foo, {adapter: 'test', bar: 'baz'})
      ModelMe::Base.specs[:foo].should_not be_nil
    end

    it 'should store it as an AdapterSpecification' do
      ModelMe::Base.add_spec(:foo, {adapter: 'dummy', bar: 'baz'})
      ModelMe::Base.specs[:foo].should be_kind_of(ModelMe::Adapters::AdapterSpecification)
    end
  end
end
