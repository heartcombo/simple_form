# frozen_string_literal: true
# encoding: UTF-8
require 'test_helper'

# Tests for datetime, date and time inputs when HTML5 compatibility is enabled in the wrapper.
class DateTimeInputWithHtml5Test < ActionView::TestCase

  test 'input generates a datetime input for datetime attributes' do
    with_input_for @user, :created_at, :datetime
    assert_select 'input[type="datetime-local"]'
  end

  test 'input generates a date input for date attributes' do
    with_input_for @user, :born_at, :date
    assert_select 'input[type="date"]'
  end

  test 'input generates a time input for time attributes' do
    with_input_for @user, :delivery_time, :time
    assert_select 'input[type="time"]'
  end

  test 'input generates required html attribute' do
    with_input_for @user, :delivery_time, :time, required: true
    assert_select 'input.required'
    assert_select 'input[required]'
  end

  test 'input has an aria-required html attribute' do
    with_input_for @user, :delivery_time, :time, required: true
    assert_select 'input[aria-required=true]'
  end

  test 'label points to attribute name' do
    with_input_for :project, :created_at, :date
    assert_select 'label[for=project_created_at]'
  end

end

# Tests for datetime, date and time inputs when HTML5 compatibility is disabled in the wrapper.
class DateTimeInputWithoutHtml5Test < ActionView::TestCase

  test 'input generates a datetime select by default for datetime attributes' do
    with_input_for @user, :created_at, :datetime, html5: false
    1.upto(5) do |i|
      assert_select "form select.datetime#user_created_at_#{i}i"
    end
  end

  test 'input is able to pass options to datetime select' do
    with_input_for @user, :created_at, :datetime, html5: false,
      disabled: true, prompt: { year: 'ano', month: 'mês', day: 'dia' }

    assert_select 'select.datetime[disabled=disabled]'
    assert_select 'select.datetime option', 'ano'
    assert_select 'select.datetime option', 'mês'
    assert_select 'select.datetime option', 'dia'
  end

  test 'input generates a date select for date attributes' do
    with_input_for @user, :born_at, :date, html5: false
    assert_select 'select.date#user_born_at_1i'
    assert_select 'select.date#user_born_at_2i'
    assert_select 'select.date#user_born_at_3i'
    assert_no_select 'select.date#user_born_at_4i'
  end

  test 'input is able to pass options to date select' do
    with_input_for @user, :born_at, :date, as: :date, html5: false,
       disabled: true, prompt: { year: 'ano', month: 'mês', day: 'dia' }

    assert_select 'select.date[disabled=disabled]'
    assert_select 'select.date option', 'ano'
    assert_select 'select.date option', 'mês'
    assert_select 'select.date option', 'dia'
  end

  test 'input is able to pass :default to date select' do
    with_input_for @user, :born_at, :date, default: Date.today, html5: false
    assert_select "select.date option[value='#{Date.today.year}'][selected=selected]"
  end

  test 'input generates a time select for time attributes' do
    with_input_for @user, :delivery_time, :time, html5: false
    assert_select 'input[type=hidden]#user_delivery_time_1i'
    assert_select 'input[type=hidden]#user_delivery_time_2i'
    assert_select 'input[type=hidden]#user_delivery_time_3i'
    assert_select 'select.time#user_delivery_time_4i'
    assert_select 'select.time#user_delivery_time_5i'
  end

  test 'input is able to pass options to time select' do
    with_input_for @user, :delivery_time, :time, required: true, html5: false,
      disabled: true, prompt: { hour: 'hora', minute: 'minuto' }

    assert_select 'select.time[disabled=disabled]'
    assert_select 'select.time option', 'hora'
    assert_select 'select.time option', 'minuto'
  end

  test 'label uses i18n to get target for date input type' do
    store_translations(:en, date: { order: %w[month day year] }) do
      with_input_for :project, :created_at, :date, html5: false
      assert_select 'label[for=project_created_at_2i]'
    end
  end

  test 'label uses i18n to get target for datetime input type' do
    store_translations(:en, date: { order: %w[month day year] }) do
      with_input_for :project, :created_at, :datetime, html5: false
      assert_select 'label[for=project_created_at_2i]'
    end
  end

  test 'label uses order to get target when date input type' do
    with_input_for :project, :created_at, :date, order: %w[month year day], html5: false
    assert_select 'label[for=project_created_at_2i]'
  end

  test 'label uses order to get target when datetime input type' do
    with_input_for :project, :created_at, :datetime, order: %w[month year day], html5: false
    assert_select 'label[for=project_created_at_2i]'
  end

  test 'label points to first option when time input type' do
    with_input_for :project, :created_at, :time, html5: false
    assert_select 'label[for=project_created_at_4i]'
  end

end
