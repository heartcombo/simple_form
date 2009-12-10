require 'test_helper'

class FormBuilderTest < ActionView::TestCase

  def with_form_for(object, attribute, options={})
    simple_form_for object do |f|
      concat f.input attribute, options
    end
  end

  test 'builder should generate text fields for string columns' do
    with_form_for @user, :name
    assert_select 'form input#user_name.string'
  end

  test 'builder should generate text areas for text columns' do
    with_form_for @user, :description
    assert_select 'form textarea#user_description.text'
  end

  test 'builder should generate a checkbox for boolean columns' do
    with_form_for @user, :active
    assert_select 'form input[type=checkbox]#user_active.boolean'
  end

  test 'builder should use integer text field for integer columns' do
    with_form_for @user, :age
    assert_select 'form input#user_age.integer'
  end

  test 'builder should generate decimal text field for decimal columns' do
    with_form_for @user, :credit_limit
    assert_select 'form input#user_credit_limit.decimal'
  end

  test 'builder should generate password fields for columns that match password' do
    with_form_for @user, :password
    assert_select 'form input#user_password.password'
  end

  test 'builder should generate date select for date columns' do
    with_form_for @user, :born_at
    assert_select 'form select#user_born_at_1i.date'
  end

  test 'builder should generate time select for time columns' do
    with_form_for @user, :delivery_time
    assert_select 'form select#user_delivery_time_4i.time'
  end

  test 'builder should generate datetime select for datetime columns' do
    with_form_for @user, :created_at
    assert_select 'form select#user_created_at_1i.datetime'
  end

  test 'builder should generate datetime select for timestamp columns' do
    with_form_for @user, :updated_at
    assert_select 'form select#user_updated_at_1i.datetime'
  end

  test 'build should generate select if a collection is given' do
    with_form_for @user, :age, :collection => 1..60
    assert_select 'form select#user_age.select'
  end

  test 'builder should allow overriding default input type for text' do
    with_form_for @user, :name, :as => :text
    assert_no_select 'form input#user_name'
    assert_select 'form textarea#user_name.text'

    with_form_for @user, :active, :as => :radio
    assert_no_select 'form input[type=checkbox]'
    assert_select 'form input.radio[type=radio]', :count => 2

    with_form_for @user, :born_at, :as => :string
    assert_no_select 'form select'
    assert_select 'form input#user_born_at.string'
  end

  test 'builder should allow passing options to input' do
    with_form_for @user, :name, :html => { :class => 'my_input', :id => 'my_input' }
    assert_select 'form input#my_input.my_input.string'
  end

  test 'builder should generate a input with label' do
    with_form_for @user, :name
    assert_select 'form label.string[for=user_name]'
  end

  test 'builder should be able to disable the label for a input' do
    with_form_for @user, :name, :label => false
    assert_no_select 'form label'
  end

  test 'builder should use custom label' do
    with_form_for @user, :name, :label => 'Yay!'
    assert_no_select 'form label', 'Yay!'
  end

  test 'builder should not generate hints for a input' do
    with_form_for @user, :name
    assert_no_select 'span.hint'
  end

  test 'builder should be able to add a hint for a input' do
    with_form_for @user, :name, :hint => 'test'
    assert_select 'span.hint', 'test'
  end

  test 'builder should be able to disable a hint even if it exists in i18n' do
    store_translations(:en, :simple_form => { :hints => { :name => 'Hint test' } }) do
      with_form_for @user, :name, :hint => false
      assert_no_select 'span.hint'
    end
  end

  test 'builder should generate errors for attribute without errors' do
    with_form_for @user, :credit_limit
    assert_no_select 'span.errors'
  end

  test 'builder should generate errors for attribute with errors' do
    with_form_for @user, :name
    assert_select 'span.error', "can't be blank"
  end

  test 'builder should be able to disable showing errors for a input' do
    with_form_for @user, :name, :error => false
    assert_no_select 'span.error'
  end

  test 'builder support wrapping around an specific tag' do
    swap SimpleForm, :wrapper_tag => :p do
      with_form_for @user, :name
      assert_select 'form p label[for=user_name]'
      assert_select 'form p input#user_name.string'
    end
  end

  test 'nested simple fields should yields an instance of FormBuilder' do
    simple_form_for :user do |f|
      f.simple_fields_for :posts do |posts_form|
        assert posts_form.instance_of?(SimpleForm::FormBuilder)
      end
    end
  end

  test 'builder should generate properly when object is not present' do
    with_form_for :project, :name
    assert_select 'form input.string#project_name'
  end

  test 'builder should generate password fields based on attribute name when object is not present' do
    with_form_for :project, :password_confirmation
    assert_select 'form input[type=password].password#project_password_confirmation'
  end

  test 'builder should generate text fields by default for all attributes when object is not present' do
    with_form_for :project, :created_at
    assert_select 'form input.string#project_created_at'
    with_form_for :project, :budget
    assert_select 'form input.string#project_budget'
  end

  test 'builder should allow overriding input type when object is not present' do
    with_form_for :project, :created_at, :as => :datetime
    assert_select 'form select.datetime#project_created_at_1i'
    with_form_for :project, :budget, :as => :decimal
    assert_select 'form input.decimal#project_budget'
  end

end
