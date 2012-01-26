# encoding: UTF-8
require 'test_helper'

class BooleanInputTest < ActionView::TestCase
  test 'input should generate a checkbox by default for boolean attributes' do
    with_input_for @user, :active, :boolean
    assert_select 'input[type=checkbox].boolean#user_active'
    assert_select 'label.boolean.optional', 'Active'
  end

  test 'input does not generate the label with the checkbox when label option is false' do
    with_input_for @user, :active, :boolean, :label => false
    assert_select 'input[type=checkbox].boolean#user_active'
    assert_no_select 'label'
  end

  test 'input uses inline checkbox style by default' do
    with_input_for @user, :active, :boolean
    assert_select 'input.boolean + label.boolean.optional'
    assert_no_select 'label > input'
  end

  test 'input allows changing default checkbox style config to nested, generating a default label' do
    swap SimpleForm, :checkbox_style => :nested do
      with_input_for @user, :active, :boolean
      assert_select 'label > input.boolean'
      assert_no_select 'label.boolean'
    end
  end

  test 'input accepts changing checkbox style through given options' do
    with_input_for @user, :active, :boolean, :checkbox_style => :nested
    assert_select 'label > input.boolean'
    assert_no_select 'label.boolean'
  end

  test 'input with nested style allows disabling label' do
    swap SimpleForm, :checkbox_style => :nested do
      with_input_for @user, :active, :boolean, :label => false
      assert_select 'input.boolean'
      assert_no_select 'label'
    end
  end
end
