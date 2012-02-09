# encoding: UTF-8
require 'test_helper'

# Tests for all different kinds of inputs.
class DateTimeInputTest < ActionView::TestCase
  # DateTime input
  test 'input should generate a datetime select by default for datetime attributes' do
    with_input_for @user, :created_at, :datetime
    1.upto(5) do |i|
      assert_select "form select.datetime#user_created_at_#{i}i"
    end
  end

  test 'input should be able to pass options to datetime select' do
    with_input_for @user, :created_at, :datetime,
      :disabled => true, :prompt => { :year => 'ano', :month => 'mês', :day => 'dia' }

    assert_select 'select.datetime[disabled=disabled]'
    assert_select 'select.datetime option', 'ano'
    assert_select 'select.datetime option', 'mês'
    assert_select 'select.datetime option', 'dia'
  end

  test 'input should generate a date select for date attributes' do
    with_input_for @user, :born_at, :date
    assert_select 'select.date#user_born_at_1i'
    assert_select 'select.date#user_born_at_2i'
    assert_select 'select.date#user_born_at_3i'
    assert_no_select 'select.date#user_born_at_4i'
  end

  test 'input should be able to pass options to date select' do
    with_input_for @user, :born_at, :date, :as => :date,
      :disabled => true, :prompt => { :year => 'ano', :month => 'mês', :day => 'dia' }

    assert_select 'select.date[disabled=disabled]'
    assert_select 'select.date option', 'ano'
    assert_select 'select.date option', 'mês'
    assert_select 'select.date option', 'dia'
  end

  test 'input should be able to pass :default to date select' do
    with_input_for @user, :born_at, :date, :default => Date.today
    assert_select "select.date option[value=#{Date.today.year}][selected=selected]"
  end

  test 'input should generate a time select for time attributes' do
    with_input_for @user, :delivery_time, :time
    assert_select 'input[type=hidden]#user_delivery_time_1i'
    assert_select 'input[type=hidden]#user_delivery_time_2i'
    assert_select 'input[type=hidden]#user_delivery_time_3i'
    assert_select 'select.time#user_delivery_time_4i'
    assert_select 'select.time#user_delivery_time_5i'
  end

  test 'input should be able to pass options to time select' do
    with_input_for @user, :delivery_time, :time, :required => true,
      :disabled => true, :prompt => { :hour => 'hora', :minute => 'minuto' }

    assert_select 'select.time[disabled=disabled]'
    assert_select 'select.time option', 'hora'
    assert_select 'select.time option', 'minuto'
  end

  test 'label should use i18n to get target for date input type' do
    store_translations(:en, :date => { :order => [:month, :day, :year] }) do
      with_input_for :project, :created_at, :date
      assert_select 'label[for=project_created_at_2i]'
    end
  end

  test 'label should use i18n to get target for datetime input type' do
    store_translations(:en, :date => { :order => [:month, :day, :year] }) do
      with_input_for :project, :created_at, :datetime
      assert_select 'label[for=project_created_at_2i]'
    end
  end

  test 'label should use order to get target when date input type' do
    with_input_for :project, :created_at, :date, :order => [:month, :year, :day]
    assert_select 'label[for=project_created_at_2i]'
  end

  test 'label should use order to get target when datetime input type' do
    with_input_for :project, :created_at, :datetime, :order => [:month, :year, :day]
    assert_select 'label[for=project_created_at_2i]'
  end

  test 'label should point to first option when time input type' do
    with_input_for :project, :created_at, :time
    assert_select 'label[for=project_created_at_4i]'
  end

  test 'date time input should not generate invalid required html attribute' do
    with_input_for @user, :delivery_time, :time, :required => true
    assert_select 'select.required'
    assert_no_select 'select[required]'
  end
end
