require 'test_helper'

class DisabledTest < ActionView::TestCase
  test 'input should generate disabled elements based on the disabled option' do
    with_input_for @user, :name, :string, :disabled => true
    assert_select 'input.string.disabled[disabled]'
    with_input_for @user, :description, :text, :disabled => true
    assert_select 'textarea.text.disabled[disabled]'
    with_input_for @user, :age, :integer, :disabled => true
    assert_select 'input.integer.disabled[disabled]'
    with_input_for @user, :born_at, :date, :disabled => true
    assert_select 'select.date.disabled[disabled]'
    with_input_for @user, :created_at, :datetime, :disabled => true
    assert_select 'select.datetime.disabled[disabled]'

    with_input_for @user, :name, :string, :disabled => false
    assert_select 'input.string:not(.disabled[disabled])'
    with_input_for @user, :description, :text, :disabled => false
    assert_select 'textarea.text:not(.disabled[disabled])'
    with_input_for @user, :age, :integer, :disabled => false
    assert_select 'input.integer:not(.disabled[disabled])'
    with_input_for @user, :born_at, :date, :disabled => false
    assert_select 'select.date:not(.disabled[disabled])'
    with_input_for @user, :created_at, :datetime, :disabled => false
    assert_select 'select.datetime:not(.disabled[disabled])'

    with_input_for @user, :name, :string
    assert_select 'input.string:not(.disabled[disabled])'
    with_input_for @user, :description, :text
    assert_select 'textarea.text:not(.disabled[disabled])'
    with_input_for @user, :age, :integer
    assert_select 'input.integer:not(.disabled[disabled])'
    with_input_for @user, :born_at, :date
    assert_select 'select.date:not(.disabled[disabled])'
    with_input_for @user, :created_at, :datetime
    assert_select 'select.datetime:not(.disabled[disabled])'
  end
end
