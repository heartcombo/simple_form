# frozen_string_literal: true
# encoding: UTF-8
require 'test_helper'

class CountryInputTest < ActionView::TestCase
  COUNTRY_SELECT_SEPARATOR =
    if Gem::Version.new(CountrySelect::VERSION) >= Gem::Version.new("11.0.0")
      "hr"
    else
      'option[value="---------------"][disabled=disabled]'
    end

  test 'input generates a country select field' do
    with_input_for @user, :country, :country
    assert_select 'select#user_country'
    assert_select 'select option[value=BR]', 'Brazil'
    assert_no_select 'select option[value=""][disabled=disabled]'
    assert_no_select "select #{COUNTRY_SELECT_SEPARATOR}"
  end

  test 'input generates a country select with SimpleForm default' do
    swap SimpleForm, country_priority: [ 'Brazil' ] do
      with_input_for @user, :country, :country
      assert_select %(select option[value="BR"] + #{COUNTRY_SELECT_SEPARATOR})
    end
  end

  test 'input generates a country select using options priority' do
    with_input_for @user, :country, :country, priority: [ 'Ukraine' ]
    assert_select %(select option[value="UA"] + #{COUNTRY_SELECT_SEPARATOR})
  end

  test 'input does generate select element with required html attribute' do
    with_input_for @user, :country, :country
    assert_select 'select.required'
    assert_select 'select[required]'
  end
end
