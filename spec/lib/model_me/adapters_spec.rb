require 'spec_helper'

describe ModelMe::Adapters do
  class AdapterModel < ModelMe::Base; end
  subject { AdapterModel }

  it { should respond_to(:adapter_manager) }
  it { should respond_to(:register_adapter) }
  it { should respond_to(:set_adapter) }

  describe 'register_adapter' do
    context 'with an invalid adapter' do
      it 'should raise an InvalidAdapter exception' do
        lambda { subject.register_adapter(:dummy, Class.new) }.should raise_error(ModelMe::InvalidAdapter)
      end
    end

    context 'with a valid adapter' do
      let(:adapter) { Class.new(ModelMe::Adapters::AbstractAdapter) }
      it 'should register with the adapter manager' do
        ModelMe::Adapters::AdapterManager.should_receive(:register).with(:dummy, adapter)
        subject.register_adapter(:dummy, adapter)
      end
    end
  end

  describe 'set_adapter' do
    context 'with nil' do
      context 'when Rails is available' do
        before {
          Object.const_set("Rails", double())
          Rails.stub(env: 'development')
        }
        after { Object.send :remove_const, :Rails }
        it 'should recurse with the environment' do
          subject.should_receive(:set_adapter).with(nil).ordered.and_call_original
          subject.should_receive(:set_adapter).with('development')
          subject.set_adapter(nil)
        end
      end

      context 'when Rails is not available' do
        it 'should raise AdapterNotSpecified' do
          lambda { subject.set_adapter(nil) }.should raise_error(ModelMe::AdapterNotSpecified)
        end
      end
    end

    context 'with a valid spec name' do
      before { ModelMe::Base.add_spec(:test, {adapter: 'dummy'}) }

      it 'should recurse with the specification' do
        subject.should_receive(:set_adapter).with(:test).ordered.and_call_original
        subject.should_receive(:set_adapter).with(an_instance_of(ModelMe::Adapters::AdapterSpecification))
        subject.set_adapter(:test)
      end
    end

    context 'with an invalid spec name' do
      it 'should raise InvalidSpecification' do
        lambda { subject.set_adapter(:invalid) }.should raise_error(ModelMe::InvalidSpecification)
      end
    end

    context 'with a full specification' do
      let(:spec) { ModelMe::Adapters::AdapterSpecification.new(:test, {adapter: 'dummy'}) }
      it 'should create an adapter' do
        ModelMe::Base.adapter_manager.should_receive(:create_adapter).with('AdapterModel', spec)
        subject.set_adapter(spec)
      end
    end
  end

  context 'with a model instance' do
    let(:model) { AdapterModel.new }
    subject { model }

    it { should respond_to(:adapter) }

    describe 'adapter' do
      it 'should retrieve an adapter' do
        AdapterModel.should_receive(:retrieve_adapter)
        subject.adapter
      end
    end
  end
end
