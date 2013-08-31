require 'spec_helper'

describe ModelMe::Reflection do
  class ReflectionModel < ModelMe::Base
    attribute :test1, :integer
  end

  class TargetModel < ModelMe::Base
    attribute :test2, :integer
  end

  subject { ReflectionModel }
  it { should respond_to(:create_reflection) }

  describe 'create_reflection' do
    it 'should store the reflections on the class' do
      r = ReflectionModel.create_reflection(:has_one, :target_model, {}, TargetModel)
      ReflectionModel.reflections.should eql(target_model: r)
    end

    it 'should return a reflection for a particular association' do
      r = ReflectionModel.create_reflection(:has_one, :target_model, {}, TargetModel)
      ReflectionModel.reflect_on_association(:target_model).should eql(r)
    end

    context 'has_one' do
      subject { ReflectionModel.create_reflection(:has_one, :target_model, {}, ReflectionModel) }
      its(:class_name) { should eql('TargetModel') }
      its(:klass) { should eql(TargetModel) }
      its(:collection?) { should be_false }
      its(:belongs_to?) { should be_false }
      its(:foreign_key) { should eql('reflection_model_id') }
      its(:association_foreign_key) { should eql('target_model_id') }
    end

    context 'has_many' do
      subject { ReflectionModel.create_reflection(:has_many, :target_models, {}, ReflectionModel) }
      its(:class_name) { should eql('TargetModel') }
      its(:klass) { should eql(TargetModel) }
      its(:collection?) { should be_true }
      its(:belongs_to?) { should be_false }
      its(:foreign_key) { should eql('reflection_model_id') }
      its(:association_foreign_key) { should eql('target_model_id') }
    end

    context 'belongs_to' do
      subject { TargetModel.create_reflection(:belongs_to, :reflection_model, {}, TargetModel) }
      its(:class_name) { should eql('ReflectionModel') }
      its(:klass) { should eql(ReflectionModel) }
      its(:collection?) { should be_false }
      its(:belongs_to?) { should be_true }
      its(:foreign_key) { should eql('reflection_model_id') }
      its(:association_foreign_key) { should eql('reflection_model_id') }
    end

    context 'has_and_belongs_to_many' do
      it 'should raise NotImplementedError' do
        lambda { ReflectionModel.create_reflection(:has_and_belongs_to_many, :target_models, {}, ReflectionModel) }.should raise_error(NotImplementedError)
      end
    end
  end
end
