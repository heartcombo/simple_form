# encoding: UTF-8
require 'test_helper'

class BooleanInputTest < ActionView::TestCase
  test 'input should generate a checkbox by default for boolean attributes' do
    with_input_for @user, :active, :boolean
    assert_select 'input[type=checkbox].boolean#user_active'
    assert_select 'input.boolean + label.boolean.optional'
  end
end