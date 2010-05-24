require 'test_helper'

class WrapperTest < ActionView::TestCase
  def with_error_for(object, attribute_name, options={}, &block)
    concat(simple_form_for object do |f|
      f.options        = options
      f.input attribute_name
    end)
  end

  test 'wrapper should not have error class for attribute without errors' do
    with_error_for @user, :active
    assert_no_select 'div.fieldWithErrors'
  end

  test 'wrapper should not have error class when object is not present' do
    with_error_for :project, :name
    assert_no_select 'div.fieldWithErrors'
  end

  test 'wrapper should add error class for attribute with errors' do
    with_error_for @user, :name
    assert_select 'div.fieldWithErrors'
  end
end
