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

  test 'input uses inline boolean style by default' do
    with_input_for @user, :active, :boolean
    assert_select 'input.boolean + label.boolean.optional'
    assert_no_select 'label > input'
  end

  test 'input allows changing default boolean style config to nested, generating a default label' do
    swap SimpleForm, :boolean_style => :nested do
      with_input_for @user, :active, :boolean
      assert_select 'label[for=user_active]', 'Active'
      assert_select 'label.boolean > input.boolean'
      assert_no_select 'input + label'
    end
  end

  test 'input accepts changing boolean style to nested through given options' do
    with_input_for @user, :active, :boolean, :boolean_style => :nested
    assert_select 'label[for=user_active]', 'Active'
    assert_select 'label.boolean > input.boolean'
    assert_no_select 'input + label'
  end

  test 'input accepts changing boolean style to inline through given options, when default is nested' do
    swap SimpleForm, :boolean_style => :nested do
      with_input_for @user, :active, :boolean, :boolean_style => :inline
      assert_select 'label[for=user_active]', 'Active'
      assert_select 'input.boolean + label.boolean'
      assert_no_select 'label > input'
    end
  end

  test 'input with nested style allows disabling label' do
    swap SimpleForm, :boolean_style => :nested do
      with_input_for @user, :active, :boolean, :label => false
      assert_select 'input.boolean'
      assert_no_select 'label'
    end
  end
end
