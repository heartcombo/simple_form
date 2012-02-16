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

  test 'input allows changing default boolean style config to nested, generating a default label and a manual hidden field for checkbox' do
    swap SimpleForm, :boolean_style => :nested do
      with_input_for @user, :active, :boolean
      assert_select 'label[for=user_active]', 'Active'
      assert_select 'label.boolean > input.boolean'
      assert_no_select 'input[type=checkbox] + label'
    end
  end

  test 'input boolean with nested generates a manual hidden field for checkbox outside the label, to recreate Rails functionality with valid html5' do
    swap SimpleForm, :boolean_style => :nested do
      with_input_for @user, :active, :boolean

      assert_select "input[type=hidden][name='user[active]'] + label.boolean > input.boolean"
      assert_no_select 'input[type=checkbox] + label'
    end
  end

  test 'input boolean with nested generates a disabled hidden field for checkbox outside the label, if the field is disabled' do
    swap SimpleForm, :boolean_style => :nested do
      with_input_for @user, :active, :boolean, :disabled => true

      assert_select "input[type=hidden][name='user[active]'][disabled] + label.boolean > input.boolean[disabled]"
    end
  end

  test 'input accepts changing boolean style to nested through given options' do
    with_input_for @user, :active, :boolean, :boolean_style => :nested
    assert_select 'label[for=user_active]', 'Active'
    assert_select 'label.boolean > input.boolean'
    assert_no_select 'input[type=checkbox] + label'
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
      assert_no_select 'label.boolean'
    end
  end

  test 'input boolean works using :input only in wrapper config (no label_input)' do
    swap_wrapper do
      with_input_for @user, :active, :boolean

      assert_select 'label.boolean + input[type=hidden] + input.boolean'
      assert_no_select 'label.checkbox'
    end
  end

  test 'input boolean with nested style works using :input only in wrapper config (no label_input), adding the extra "checkbox" label wrapper' do
    swap_wrapper do
      swap SimpleForm, :boolean_style => :nested do
        with_input_for @user, :active, :boolean

        assert_select 'label.boolean + input[type=hidden] + label.checkbox > input.boolean'
      end
    end
  end

  test 'input boolean with nested style works using :label_input in wrapper config, adding "checkbox" class to label' do
    swap_wrapper :default, self.custom_wrapper_without_top_level do
      swap SimpleForm, :boolean_style => :nested do
        with_input_for @user, :active, :boolean

        assert_select 'input[type=hidden] + label.boolean.checkbox > input.boolean'
      end
    end
  end
end
