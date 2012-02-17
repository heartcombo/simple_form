# encoding: UTF-8
require 'test_helper'

class PriorityInputTest < ActionView::TestCase
  test 'input should generate a country select field' do
    with_input_for @user, :country, :country
    assert_select 'select#user_country'
    assert_select 'select option[value=Brazil]', 'Brazil'
    assert_no_select 'select option[value=][disabled=disabled]'
  end

  test 'input should generate a country select with SimpleForm default' do
    swap SimpleForm, :country_priority => [ 'Brazil' ] do
      with_input_for @user, :country, :country
      assert_select 'select option[value=][disabled=disabled]'
    end
  end

  test 'input should generate a time zone select field' do
    with_input_for @user, :time_zone, :time_zone
    assert_select 'select#user_time_zone'
    assert_select 'select option[value=Brasilia]', '(GMT-03:00) Brasilia'
    assert_no_select 'select option[value=][disabled=disabled]'
  end

  test 'input should generate a time zone select field with default' do
    with_input_for @user, :time_zone, :time_zone, :default => 'Brasilia'
    assert_select 'select option[value=Brasilia][selected=selected]'
    assert_no_select 'select option[value=]'
  end

  test 'input should generate a time zone select using options priority' do
    with_input_for @user, :time_zone, :time_zone, :priority => /Brasilia/
    assert_select 'select option[value=][disabled=disabled]'
    assert_no_select 'select option[value=]', /^$/
  end

  test 'priority input should not generate invalid required html attribute' do
    with_input_for @user, :country, :country
    assert_select 'select.required'
    assert_no_select 'select[required]'
  end
end
