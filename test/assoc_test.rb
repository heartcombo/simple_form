require 'test_helper'

class AssocTest < ActiveSupport::TestCase

  test 'initialize via constructor block' do
    actual = SimpleForm::Association.new do |assoc|
      assoc.klass = Company
      assoc.macro = :belongs_to
      assoc.name = :company
      assoc.options[:foreign_key] = 'parent_company_id'
    end
    assert_equal Company, actual.klass
    assert_equal :belongs_to, actual.macro
    assert_equal :company, actual.name
    assert_equal 'parent_company_id', actual.options[:foreign_key]
  end

end
