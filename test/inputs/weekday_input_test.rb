# frozen_string_literal: true
# encoding: UTF-8
require 'test_helper'

class WeekdayInputTest < ActionView::TestCase
  test 'input generates a weekday select' do
    with_input_for @user, :born_at, :weekday
    assert_select 'select.weekday#user_born_at'
  end

  test 'input generates a weekday select that accepts placeholder' do
    with_input_for @user, :born_at, :weekday, placeholder: 'Put in a weekday'
    assert_select 'select.weekday[placeholder="Put in a weekday"]'
  end
end
