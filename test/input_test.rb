require 'test_helper'

class InputTest < ActionView::TestCase

  test 'input should verify options hash' do
    assert_raise ArgumentError do
      simple_form_for @user do |f|
        concat f.input :name, :invalid_param => true
      end
    end
  end

  test 'input should generate a default text field' do
    simple_form_for @user do |f|
      concat f.input :name
    end
    assert_select 'form input[name=\'user[name]\'][id=user_name][value=New in Simple Form!]'
  end

  test 'input should generate a default class for each input' do
    simple_form_for @user do |f|
      concat f.input :name
    end
    assert_select 'form input#user_name.string'
  end

  test 'input should allow passing options to text field' do
    simple_form_for @user do |f|
      concat f.input :name, :html => { :class => 'my_input', :id => 'my_input' }
    end
    assert_select 'form input#my_input.my_input.string'
  end

  test 'input should generate a text area by default for text attributes' do
    simple_form_for @user do |f|
      concat f.input :description
    end
    assert_select 'form textarea.text#user_description'
  end

  test 'input should generate a text field by default for integer attributes' do
    simple_form_for @user do |f|
      concat f.input :age
    end
    assert_select "form input.integer#user_age"
  end

  test 'input should generate a text field by default for decimal attributes' do
    simple_form_for @user do |f|
      concat f.input :credit_limit
    end
    assert_select "form input.decimal#user_credit_limit"
  end

  test 'input should generate a checkbox by default for boolean attributes' do
    simple_form_for @user do |f|
      concat f.input :active
    end
    assert_select "form input[type=checkbox].boolean#user_active"
  end

  test 'input should generate a datetime select by default for datetime or timestamp attributes' do
    simple_form_for @user do |f|
      concat f.input :created_at
      concat f.input :updated_at
    end
    1.upto(5) do |i|
      assert_select "form select.datetime#user_created_at_#{i}i"
      assert_select "form select.datetime#user_updated_at_#{i}i"
    end
  end

  test 'input should be able to pass options to datetime select' do
    simple_form_for @user do |f|
      concat f.input :created_at, :options => {
        :disabled => true, :prompt => { :year => 'ano', :month => 'mês', :day => 'dia' }
      }
    end
    assert_tag :tag => 'select', :attributes => { :disabled => 'disabled' }
    assert_select 'form select.datetime option', 'ano'
    assert_select 'form select.datetime option', 'mês'
    assert_select 'form select.datetime option', 'dia'
  end

  test 'input should generate a date select by default for date attributes' do
    simple_form_for @user do |f|
      concat f.input :born_at
    end
    assert_select "form select.date#user_born_at_1i"
    assert_select "form select.date#user_born_at_2i"
    assert_select "form select.date#user_born_at_3i"
    assert_no_tag :tag => 'select', :attributes => { :id => "user_born_at_4i" }
  end

  test 'input should be able to pass options to date select' do
    simple_form_for @user do |f|
      concat f.input :born_at, :options => {
        :disabled => true, :prompt => { :year => 'ano', :month => 'mês', :day => 'dia' }
      }
    end
    assert_tag :tag => 'select', :attributes => { :disabled => 'disabled' }
    assert_select 'form select.date option', 'ano'
    assert_select 'form select.date option', 'mês'
    assert_select 'form select.date option', 'dia'
  end

  test 'input should generate a time select by default for time attributes' do
    simple_form_for @user do |f|
      concat f.input :delivery_time
    end
    assert_select "form input[type=hidden]#user_delivery_time_1i"
    assert_select "form input[type=hidden]#user_delivery_time_2i"
    assert_select "form input[type=hidden]#user_delivery_time_3i"
    assert_select "form select.time#user_delivery_time_4i"
    assert_select "form select.time#user_delivery_time_5i"
  end

  test 'input should be able to pass options to time select' do
    simple_form_for @user do |f|
      concat f.input :delivery_time, :options => {
        :disabled => true, :prompt => { :hour => 'hora', :minute => 'minuto' }
      }
    end
    assert_tag :tag => 'select', :attributes => { :disabled => 'disabled' }
    assert_select 'form select.time option', 'hora'
    assert_select 'form select.time option', 'minuto'
  end

  test 'input should allow overwriting default type' do
    simple_form_for @user do |f|
      concat f.input :name, :as => :text
      concat f.input :born_at, :as => :string
    end
    assert_select 'form textarea.text#user_name'
    assert_select 'form input.string#user_born_at'
  end

  test 'input should allow boolean fields as radio buttons' do
    simple_form_for @user do |f|
      concat f.input :active, :as => :radio
    end
    assert_select 'form input[type=radio][value=yes].radio#user_active_yes'
    assert_select 'form input[type=radio][value=no].radio#user_active_no'
  end

  test 'input should generate a password field for password attributes' do
    simple_form_for @user do |f|
      concat f.input :password
    end
    assert_select 'form input[type=password].password#user_password'
  end

end
