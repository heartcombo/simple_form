require 'test_helper'

class ReadonlyTest < ActionView::TestCase
  test 'input should generate readonly elements based on the readonly option' do
    with_input_for @user, :name, :string, :readonly => true
    assert_select 'input.string.readonly[readonly]'
    with_input_for @user, :description, :text, :readonly => true
    assert_select 'textarea.text.readonly[readonly]'
    with_input_for @user, :age, :integer, :readonly => true
    assert_select 'input.integer.readonly[readonly]'
    with_input_for @user, :born_at, :date, :readonly => true
    assert_select 'select.date.readonly[readonly]'
    with_input_for @user, :created_at, :datetime, :readonly => true
    assert_select 'select.datetime.readonly[readonly]'

    with_input_for @user, :name, :string, :readonly => false
    assert_select 'input.string:not(.readonly[readonly])'
    with_input_for @user, :description, :text, :readonly => false
    assert_select 'textarea.text:not(.readonly[readonly])'
    with_input_for @user, :age, :integer, :readonly => false
    assert_select 'input.integer:not(.readonly[readonly])'
    with_input_for @user, :born_at, :date, :readonly => false
    assert_select 'select.date:not(.readonly[readonly])'
    with_input_for @user, :created_at, :datetime, :readonly => false
    assert_select 'select.datetime:not(.readonly[readonly])'

    with_input_for @user, :name, :string
    assert_select 'input.string:not(.readonly[readonly])'
    with_input_for @user, :description, :text
    assert_select 'textarea.text:not(.readonly[readonly])'
    with_input_for @user, :age, :integer
    assert_select 'input.integer:not(.readonly[readonly])'
    with_input_for @user, :born_at, :date
    assert_select 'select.date:not(.readonly[readonly])'
    with_input_for @user, :created_at, :datetime
    assert_select 'select.datetime:not(.readonly[readonly])'
  end

  test 'input should generate readonly attribute when the field is readonly and the object is persisted' do
    with_input_for @user, :credit_card, :string, :readonly => :lookup
    assert_select 'input.string.readonly[readonly]'
  end

  test 'input should not generate readonly attribute when the field is readonly and the object is not persisted' do
    @user.new_record!
    with_input_for @user, :credit_card, :string, :readonly => :lookup
    assert_no_select 'input.string.readonly[readonly]'
  end

  test 'input should not generate readonly attribute when the field is not readonly and the object is persisted' do
    with_input_for @user, :name, :string
    assert_no_select 'input.string.readonly[readonly]'
  end

  test 'input should not generate readonly attribute when the component is not used' do
    swap_wrapper do
      with_input_for @user, :credit_card, :string
      assert_no_select 'input.string.readonly[readonly]'
    end
  end
end
