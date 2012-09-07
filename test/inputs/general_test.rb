# encoding: UTF-8
require 'test_helper'

class InputTest < ActionView::TestCase
  test 'input should generate css class based on default input type' do
    with_input_for @user, :name, :string
    assert_select 'input.string'
    with_input_for @user, :description, :text
    assert_select 'textarea.text'
    with_input_for @user, :age, :integer
    assert_select 'input.integer'
    with_input_for @user, :born_at, :date
    assert_select 'select.date'
    with_input_for @user, :created_at, :datetime
    assert_select 'select.datetime'
  end

  test 'string input should generate autofocus attribute when autofocus option is true' do
    with_input_for @user, :name, :string, :autofocus => true
    assert_select 'input.string[autofocus]'
  end

  test 'text input should generate autofocus attribute when autofocus option is true' do
    with_input_for @user, :description, :text, :autofocus => true
    assert_select 'textarea.text[autofocus]'
  end

  test 'numeric input should generate autofocus attribute when autofocus option is true' do
    with_input_for @user, :age, :integer, :autofocus => true
    assert_select 'input.integer[autofocus]'
  end

  test 'date input should generate autofocus attribute when autofocus option is true' do
    with_input_for @user, :born_at, :date, :autofocus => true
    assert_select 'select.date[autofocus]'
  end

  test 'datetime input should generate autofocus attribute when autofocus option is true' do
    with_input_for @user, :created_at, :datetime, :autofocus => true
    assert_select 'select.datetime[autofocus]'
  end

  test 'string input should generate autofocus attribute when autofocus option is false' do
    with_input_for @user, :name, :string, :autofocus => false
    assert_no_select 'input.string[autofocus]'
  end

  test 'text input should generate autofocus attribute when autofocus option is false' do
    with_input_for @user, :description, :text, :autofocus => false
    assert_no_select 'textarea.text[autofocus]'
  end

  test 'numeric input should generate autofocus attribute when autofocus option is false' do
    with_input_for @user, :age, :integer, :autofocus => false
    assert_no_select 'input.integer[autofocus]'
  end

  test 'date input should generate autofocus attribute when autofocus option is false' do
    with_input_for @user, :born_at, :date, :autofocus => false
    assert_no_select 'select.date[autofocus]'
  end

  test 'datetime input should generate autofocus attribute when autofocus option is false' do
    with_input_for @user, :created_at, :datetime, :autofocus => false
    assert_no_select 'select.datetime[autofocus]'
  end

  test 'string input should generate autofocus attribute when autofocus option is not present' do
    with_input_for @user, :name, :string
    assert_no_select 'input.string[autofocus]'
  end

  test 'text input should generate autofocus attribute when autofocus option is not present' do
    with_input_for @user, :description, :text
    assert_no_select 'textarea.text[autofocus]'
  end

  test 'numeric input should generate autofocus attribute when autofocus option is not present' do
    with_input_for @user, :age, :integer
    assert_no_select 'input.integer[autofocus]'
  end

  test 'date input should generate autofocus attribute when autofocus option is not present' do
    with_input_for @user, :born_at, :date
    assert_no_select 'select.date[autofocus]'
  end

  test 'datetime input should generate autofocus attribute when autofocus option is not present' do
    with_input_for @user, :created_at, :datetime
    assert_no_select 'select.datetime[autofocus]'
  end

  # With no object
  test 'input should be generated properly when object is not present' do
    with_input_for :project, :name, :string
    assert_select 'input.string.required#project_name'
  end

  test 'input as radio should be generated properly when object is not present ' do
    with_input_for :project, :name, :radio_buttons
    assert_select 'input.radio_buttons#project_name_true'
    assert_select 'input.radio_buttons#project_name_false'
  end

  test 'input as select with collection should be generated properly when object is not present' do
    with_input_for :project, :name, :select, :collection => ['Jose', 'Carlos']
    assert_select 'select.select#project_name'
  end

  test 'input should not generate empty css class' do
    swap SimpleForm, :generate_additional_classes_for => [:wrapper, :label] do
      with_input_for :project, :name, :string
      assert_no_select 'input#project_name[class]'
    end
  end
end
