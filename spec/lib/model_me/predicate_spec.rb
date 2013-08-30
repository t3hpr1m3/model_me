require 'spec_helper'

describe ModelMe::Predicate do
  let(:pred) { ModelMe::Predicate.new(:var, :ge) }
  subject { pred }

  it { should respond_to(:value=) }
  its(:attribute) { should eql(:var) }
  its(:meth) { should eql(:ge) }

  it 'should have a value after update' do
    subject.value = 'valued'
    subject.has_value?.should be_true
  end

  describe 'test' do
    context 'with a @value of 1' do
      def expectations
        { eq: false, ne: true, gt: true, gte: true, lt: false, lte: false }
      end

      ModelMe::Predicate::PREDICATES.each do |p|
        if p.eql?(:in)
          subject { ModelMe::Predicate.new(:var, :in, 1) }
          describe ':in 2' do
            specify { lambda { subject.test(2) }.should raise_error }
          end
          describe ':in [2]' do
            subject { ModelMe::Predicate.new(:var, :in, [2]) }
            specify { subject.test(2).should be_true }
          end
        else
          describe ":#{p} 2" do
            specify { ModelMe::Predicate.new(:var, p, 1).test(2).should eql(expectations[p]) }
          end
        end
      end
    end
  end
end
