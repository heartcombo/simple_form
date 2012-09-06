require 'test_helper'

class DisabledTest < ActionView::TestCase
  test 'string input should be disabled when disabled option is true' do
    with_input_for @user, :name, :string, :disabled => true
    assert_select 'input.string.disabled[disabled]'
  end

  test 'text input should be disabled when disabled option is true' do
    with_input_for @user, :description, :text, :disabled => true
    assert_select 'textarea.text.disabled[disabled]'
  end

  test 'numeric input should be disabled when disabled option is true' do
    with_input_for @user, :age, :integer, :disabled => true
    assert_select 'input.integer.disabled[disabled]'
  end

  test 'date input should be disabled when disabled option is true' do
    with_input_for @user, :born_at, :date, :disabled => true
    assert_select 'select.date.disabled[disabled]'
  end

  test 'datetime input should be disabled when disabled option is true' do
    with_input_for @user, :created_at, :datetime, :disabled => true
    assert_select 'select.datetime.disabled[disabled]'
  end

  test 'string input should not be disabled when disabled option is false' do
    with_input_for @user, :name, :string, :disabled => false
    assert_no_select 'input.string.disabled[disabled]'
  end

  test 'text input should not be disabled when disabled option is false' do
    with_input_for @user, :description, :text, :disabled => false
    assert_no_select 'textarea.text.disabled[disabled]'
  end

  test 'numeric input should not be disabled when disabled option is false' do
    with_input_for @user, :age, :integer, :disabled => false
    assert_no_select 'input.integer.disabled[disabled]'
  end

  test 'date input should not be disabled when disabled option is false' do
    with_input_for @user, :born_at, :date, :disabled => false
    assert_no_select 'select.date.disabled[disabled]'
  end

  test 'datetime input should not be disabled when disabled option is false' do
    with_input_for @user, :created_at, :datetime, :disabled => false
    assert_no_select 'select.datetime.disabled[disabled]'
  end

  test 'string input should not be disabled when disabled option is not present' do
    with_input_for @user, :name, :string
    assert_no_select 'input.string.disabled[disabled]'
  end

  test 'text input should not be disabled when disabled option is not present' do
    with_input_for @user, :description, :text
    assert_no_select 'textarea.text.disabled[disabled]'
  end

  test 'numeric input should not be disabled when disabled option is not present' do
    with_input_for @user, :age, :integer
    assert_no_select 'input.integer.disabled[disabled]'
  end

  test 'date input should not be disabled when disabled option is not present' do
    with_input_for @user, :born_at, :date
    assert_no_select 'select.date.disabled[disabled]'
  end

  test 'datetime input should not be disabled when disabled option is not present' do
    with_input_for @user, :created_at, :datetime
    assert_no_select 'select.datetime.disabled[disabled]'
  end
end
