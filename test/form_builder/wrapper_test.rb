require 'test_helper'

class WrapperTest < ActionView::TestCase
  test 'wrapper should not have error class for attribute without errors' do
    with_form_for @user, :active
    assert_no_select 'div.field_with_errors'
  end

  test 'wrapper should not have error class when object is not present' do
    with_form_for :project, :name
    assert_no_select 'div.field_with_errors'
  end

  test 'wrapper should add error class for attribute with errors' do
    with_form_for @user, :name
    assert_select 'div.field_with_errors'
  end

  test 'wrapper should not have disabled class by default' do
    with_form_for @user, :active
    assert_no_select 'div.disabled'
  end
  
  test 'wrapper should support no wrapping when wrapper is false' do
    with_form_for @user, :name, :wrapper => false	
    assert_select 'form > label[for=user_name]'	
    assert_select 'form > input#user_name.string'
  end

  test 'wrapper should wrapping tag adds required/optional css classes' do
    with_form_for @user, :name
    assert_select 'form div.input.required.string'

    with_form_for @user, :age, :required => false
    assert_select 'form div.input.optional.integer'
  end

  test 'wrapper should allow custom options to be given' do
    with_form_for @user, :name, :wrapper_html => { :id => "super_cool", :class => 'yay' }
    assert_select 'form #super_cool.required.string.yay'
  end

  test 'wrapper should allow tag to be given on demand' do
    with_form_for @user, :name, :wrapper_tag => :b
    assert_select 'form b.required.string'
  end

  test 'wrapper should allow wrapper class to be given on demand' do
    with_form_for @user, :name, :wrapper_class => :wrapper
    assert_select 'form div.wrapper.required.string'
  end

  # Custom wrapper test

  test 'custom wrappers works' do
    swap_wrapper do
      with_form_for @user, :name, :hint => "cool"
      assert_select "section.custom_wrapper div.another_wrapper label"
      assert_select "section.custom_wrapper div.another_wrapper input.string"
      assert_no_select "section.custom_wrapper div.another_wrapper span.omg_error"
      assert_select "section.custom_wrapper div.error_wrapper span.omg_error"
      assert_select "section.custom_wrapper > span.omg_hint", "cool"
    end
  end

  test 'custom wrappers can be turned off' do
    swap_wrapper do
      with_form_for @user, :name, :another => false
      assert_no_select "section.custom_wrapper div.another_wrapper label"
      assert_no_select "section.custom_wrapper div.another_wrapper input.string"
      assert_select "section.custom_wrapper div.error_wrapper span.omg_error"
    end
  end
end
