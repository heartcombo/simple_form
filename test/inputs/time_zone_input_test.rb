# frozen_string_literal: true
# encoding: UTF-8
require 'test_helper'

class TimeZoneInputTest < ActionView::TestCase
  test 'input generates a time zone select field' do
    with_input_for @user, :time_zone, :time_zone
    assert_select 'select#user_time_zone'
    assert_select 'select option[value=Brasilia]', '(GMT-03:00) Brasilia'
    assert_no_select 'select option[value=""][disabled=disabled]'
  end

  test 'input generates a time zone select field with default' do
    with_input_for @user, :time_zone, :time_zone, default: 'Brasilia'
    assert_select 'select option[value=Brasilia][selected=selected]'
    assert_no_select 'select option[value=""]'
  end

  test 'input generates a time zone select using options priority' do
    with_input_for @user, :time_zone, :time_zone, priority: /Brasilia/
    assert_select 'select option[value=""][disabled=disabled]'
    assert_no_select 'select option[value=""]', /^$/
  end

  test 'input does generate select element with required html attribute' do
    with_input_for @user, :time_zone, :time_zone
    assert_select 'select.required'
    assert_select 'select[required]'
  end

  test 'input does generate select element with aria-required html attribute' do
    with_input_for @user, :time_zone, :time_zone
    assert_select 'select.required'
    assert_select 'select[aria-required]'
  end
end
