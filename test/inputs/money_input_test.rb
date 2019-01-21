# frozen_string_literal: true
require 'test_helper'

class MoneyTest < ActionView::TestCase
  test 'input maps money field to string attribute' do
    with_input_for @user, :amount, :money

    assert_select "input.money[type=text][name='user[amount]']"
  end
end
