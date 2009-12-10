require 'test_helper'

class FormBuilderTest < ActionView::TestCase

  def with_form_for(attribute, options={})
    simple_form_for @user do |f|
      concat f.input attribute, options
    end
  end

  test 'builder should generate text fields for string columns' do
    with_form_for :name
    assert_select 'form input#user_name.string'
  end

  test 'builder should generate text areas for text columns' do
    with_form_for :description
    assert_select 'form textarea#user_description.text'
  end

  test 'builder should generate a checkbox for boolean columns' do
    with_form_for :active
    assert_select 'form input[type=checkbox]#user_active.boolean'
  end

  test 'builder should use integer text field for integer columns' do
    with_form_for :age
    assert_select 'form input#user_age.integer'
  end

  test 'builder should generate decimal text field for decimal columns' do
    with_form_for :credit_limit
    assert_select 'form input#user_credit_limit.decimal'
  end

  test 'builder should generate password fields for columns that match password' do
    with_form_for :password
    assert_select 'form input#user_password.password'
  end

  test 'builder should generate date select for date columns' do
    with_form_for :born_at
    assert_select 'form select#user_born_at_1i.date'
  end

  test 'builder should generate time select for time columns' do
    with_form_for :delivery_time
    assert_select 'form select#user_delivery_time_4i.time'
  end

  test 'builder should generate datetime select for datetime columns' do
    with_form_for :created_at
    assert_select 'form select#user_created_at_1i.datetime'
  end

  test 'builder should generate datetime select for timestamp columns' do
    with_form_for :updated_at
    assert_select 'form select#user_updated_at_1i.datetime'
  end

  test 'builder should allow overriding default input type for text' do
    with_form_for :name, :as => :text
    assert_no_select 'form input#user_name'
    assert_select 'form textarea#user_name.text'

    with_form_for :active, :as => :radio
    assert_no_select 'form input[type=checkbox]'
    assert_select 'form input.radio[type=radio]', :count => 2

    with_form_for :born_at, :as => :string
    assert_no_select 'form select'
    assert_select 'form input#user_born_at.string'
  end

  test 'builder should allow passing options to input' do
    with_form_for :name, :html => { :class => 'my_input', :id => 'my_input' }
    assert_select 'form input#my_input.my_input.string'
  end

  test 'builder should generate a input with label' do
    with_form_for :name
    assert_select 'form label.string[for=user_name]'
  end

  test 'builder should be able to disable the label for a input' do
    with_form_for :name, :label => false
    assert_no_select 'form label'
  end

  test 'builder should use custom label' do
    with_form_for :name, :label => 'Yay!'
    assert_no_select 'form label', 'Yay!'
  end

  test 'builder should not generate hints for a input' do
    with_form_for :name
    assert_no_select 'span.hint'
  end

  test 'builder should be able to add a hint for a input' do
    with_form_for :name, :hint => 'test'
    assert_select 'span.hint', 'test'
  end

  test 'builder should be able to disable a hint even if it exists in i18n' do
    store_translations(:en, :simple_form => { :hints => { :name => 'Hint test' } }) do
      with_form_for :name, :hint => false
      assert_no_select 'span.hint'
    end
  end

  test 'builder should generate errors for attribute without errors' do
    with_form_for :credit_limit
    assert_no_select 'span.errors'
  end

  test 'builder should generate errors for attribute with errors' do
    with_form_for :name
    assert_select 'span.error', "can't be blank"
  end

  test 'builder should be able to disable showing errors for a input' do
    with_form_for :name, :error => false
    assert_no_select 'span.error'
  end
end
