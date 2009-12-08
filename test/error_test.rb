require 'test_helper'

class ErrorTest < ActionView::TestCase

  def setup
    @super_user = SuperUser.new
  end

  test 'input should not generate error by default' do
    simple_form_for @user do |f|
      concat f.input :name
    end
    assert_no_select 'form span.error'
  end

  test 'input should generate error messages for attributes with a single error' do
    simple_form_for @super_user do |f|
      concat f.input :name
      concat f.input :description
    end
    assert_select 'form span.error', "can't be blank"
    assert_select 'form span.error', "must be longer than 15 characters"
  end

  test 'input should generate error messages for attributes with several errors' do
    simple_form_for @super_user do |f|
      concat f.input :age
      concat f.input :credit_limit
    end
    assert_select 'form span.error', "is not a number and must be greater than 18"
    assert_select 'form span.error', "must be present and must be greater than 0"
  end
end
