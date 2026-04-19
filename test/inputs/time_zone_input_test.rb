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

  test 'input generates a time zone select with a custom collection' do
    with_input_for @user, :time_zone, :time_zone, collection: [['London', 'London'], ['Berlin', 'Berlin']]
    assert_select 'select#user_time_zone'
    assert_select 'select option', count: 3 # 2 zones + include_blank
    assert_select 'select option[value=London]', 'London'
    assert_select 'select option[value=Berlin]', 'Berlin'
  end

  test 'input generates a time zone select with ActiveSupport::TimeZone objects' do
    collection = ['London', 'Berlin'].map { |tz| ActiveSupport::TimeZone[tz] }

    with_input_for @user, :time_zone, :time_zone, collection: collection, include_blank: false
    assert_select 'select#user_time_zone'
    assert_select 'select option', count: 2
  end

  test 'input does generate select element with required html attribute' do
    with_input_for @user, :time_zone, :time_zone
    assert_select 'select.required'
    assert_select 'select[required]'
  end
end
