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

  test 'input should generate disabled elements based on the disabled option' do
    with_input_for @user, :name, :string, :disabled => true
    assert_select 'input.string[disabled]'
    with_input_for @user, :description, :text, :disabled => true
    assert_select 'textarea.text[disabled]'
    with_input_for @user, :age, :integer, :disabled => true
    assert_select 'input.integer[disabled]'
    with_input_for @user, :born_at, :date, :disabled => true
    assert_select 'select.date[disabled]'
    with_input_for @user, :created_at, :datetime, :disabled => true
    assert_select 'select.datetime[disabled]'

    with_input_for @user, :name, :string, :disabled => false
    assert_select 'input.string:not([disabled])'
    with_input_for @user, :description, :text, :disabled => false
    assert_select 'textarea.text:not([disabled])'
    with_input_for @user, :age, :integer, :disabled => false
    assert_select 'input.integer:not([disabled])'
    with_input_for @user, :born_at, :date, :disabled => false
    assert_select 'select.date:not([disabled])'
    with_input_for @user, :created_at, :datetime, :disabled => false
    assert_select 'select.datetime:not([disabled])'

    with_input_for @user, :name, :string
    assert_select 'input.string:not([disabled])'
    with_input_for @user, :description, :text
    assert_select 'textarea.text:not([disabled])'
    with_input_for @user, :age, :integer
    assert_select 'input.integer:not([disabled])'
    with_input_for @user, :born_at, :date
    assert_select 'select.date:not([disabled])'
    with_input_for @user, :created_at, :datetime
    assert_select 'select.datetime:not([disabled])'
  end

  test 'input should generate autofocus attribute based on the autofocus option' do
    with_input_for @user, :name, :string, :autofocus => true
    assert_select 'input.string[autofocus]'
    with_input_for @user, :description, :text, :autofocus => true
    assert_select 'textarea.text[autofocus]'
    with_input_for @user, :age, :integer, :autofocus => true
    assert_select 'input.integer[autofocus]'
    with_input_for @user, :born_at, :date, :autofocus => true
    assert_select 'select.date[autofocus]'
    with_input_for @user, :created_at, :datetime, :autofocus => true
    assert_select 'select.datetime[autofocus]'

    with_input_for @user, :name, :string, :autofocus => false
    assert_select 'input.string:not([autofocus])'
    with_input_for @user, :description, :text, :autofocus => false
    assert_select 'textarea.text:not([autofocus])'
    with_input_for @user, :age, :integer, :autofocus => false
    assert_select 'input.integer:not([autofocus])'
    with_input_for @user, :born_at, :date, :autofocus => false
    assert_select 'select.date:not([autofocus])'
    with_input_for @user, :created_at, :datetime, :autofocus => false
    assert_select 'select.datetime:not([autofocus])'

    with_input_for @user, :name, :string
    assert_select 'input.string:not([autofocus])'
    with_input_for @user, :description, :text
    assert_select 'textarea.text:not([autofocus])'
    with_input_for @user, :age, :integer
    assert_select 'input.integer:not([autofocus])'
    with_input_for @user, :born_at, :date
    assert_select 'select.date:not([autofocus])'
    with_input_for @user, :created_at, :datetime
    assert_select 'select.datetime:not([autofocus])'
  end

  # BooleanInput
  test 'input should generate a checkbox by default for boolean attributes' do
    with_input_for @user, :active, :boolean
    assert_select 'input[type=checkbox].boolean#user_active'
    assert_select 'input.boolean + label.boolean.optional'
  end

  # TextInput
  test 'input should generate a text area for text attributes' do
    with_input_for @user, :description, :text
    assert_select 'textarea.text#user_description'
  end

  test 'input should generate a text area for text attributes that accept placeholder' do
    with_input_for @user, :description, :text, :placeholder => 'Put in some text'
    assert_select 'textarea.text[placeholder=Put in some text]'
  end

  test 'input should get maxlength from column definition for text attributes' do
    with_input_for @user, :description, :text
    assert_select 'textarea.text[maxlength=200]'
  end

  test 'input should infer maxlength column definition from validation when present for text attributes' do
    with_input_for @validating_user, :description, :text
    assert_select 'textarea.text[maxlength=50]'
  end

  test 'when not using HTML5, does not show maxlength attribute for text attributes' do
    swap SimpleForm, :html5 => false do
      with_input_for @user, :description, :text
      assert_no_select 'textarea.text[maxlength]'
    end
  end

  test 'when not using HTML5, does not show maxlength attribute with validating lenght text attribute' do
    swap SimpleForm, :html5 => false do
      with_input_for @validating_user, :name, :string
      assert_no_select 'input.string[maxlength]'
    end
  end

  # FileInput
  test 'input should generate a file field' do
    with_input_for @user, :name, :file
    assert_select 'input#user_name[type=file]'
  end

  test "input should generate a file field that doesn't accept placeholder" do
    with_input_for @user, :name, :file, :placeholder => 'Put in some text'
    assert_no_select 'input[placeholder]'
  end

  # HiddenInput
  test 'input should generate a hidden field' do
    with_input_for @user, :name, :hidden
    assert_no_select 'input[type=text]'
    assert_select 'input#user_name[type=hidden]'
  end

  test 'hint should not be generated for hidden fields' do
    with_input_for @user, :name, :hidden, :hint => 'Use with care...'
    assert_no_select 'span.hint'
  end

  test 'label should not be generated for hidden inputs' do
    with_input_for @user, :name, :hidden
    assert_no_select 'label'
  end

  test 'required/optional options should not be generated for hidden inputs' do
    with_input_for @user, :name, :hidden
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_no_select 'input.optional'
    assert_select 'input.hidden#user_name'
  end

  # With no object
  test 'input should be generated properly when object is not present' do
    with_input_for :project, :name, :string
    assert_select 'input.string.required#project_name'
  end

  test 'input as radio should be generated properly when object is not present ' do
    with_input_for :project, :name, :radio
    assert_select 'input.radio#project_name_true'
    assert_select 'input.radio#project_name_false'
  end

  test 'input as select with collection should be generated properly when object is not present' do
    with_input_for :project, :name, :select, :collection => ['Jose', 'Carlos']
    assert_select 'select.select#project_name'
  end
end
