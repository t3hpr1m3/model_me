require 'spec_helper'

describe ModelMe::Base do
  class LintTester < ModelMe::Base; end

  subject { LintTester.new }

  it_should_behave_like 'ActiveModel'
end
