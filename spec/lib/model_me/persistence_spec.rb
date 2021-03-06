require 'spec_helper'

describe ModelMe::Persistence do
  class PersistenceModel < ModelMe::Base
    attribute :test, :string
    validates :test, numericality: true, on: :create

    after_destroy :destroy_callback

    def destroy_callback; end
  end

  let(:model) { PersistenceModel.new }

  subject { model }
  it { should respond_to(:save) }
  it { should respond_to(:create) }
  it { should respond_to(:update) }
  it { should respond_to(:destroy) }
  it { should respond_to(:reload) }
  it { should respond_to(:update_attributes) }
  it { should respond_to(:new_record?) }
  it { should respond_to(:destroyed?) }
  it { should respond_to(:persisted?) }
  its(:new_record?) { should be_true }
  its(:destroyed?) { should be_false }
  its(:persisted?) { should be_false }

  it 'should trigger the proper validations on create' do
    subject.stub(persisted?: false, new_record?: true)
    subject.test = 'foo'
    subject.save.should be_false
  end

  it 'should trigger the proper validations on update' do
    subject.stub(persisted?: true, new_record?: false)
    subject.test = 'foo'
    subject.save.should be_true
  end

  it 'should trigger the destroy callback' do
    subject.should_receive(:destroy_callback)
    subject.destroy
  end
end
