require 'test_helper'

class ColumnTest < ActiveSupport::TestCase

  test 'initialize via contructors block' do
    actual = SimpleForm::Column.new do |col|
      col.type = :string
      col.limit = 255
    end
    assert_equal :string, actual.type
    assert_equal 255, actual.limit
  end

  test 'can identify number' do
    assert !SimpleForm::Column.new {|c| c.type = :string}.number?
    assert SimpleForm::Column.new {|c| c.type = :integer}.number?
    assert SimpleForm::Column.new {|c| c.type = :float}.number?
    assert SimpleForm::Column.new {|c| c.type = :decimal}.number?
  end

end
