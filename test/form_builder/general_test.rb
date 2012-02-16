# encoding: UTF-8
require 'test_helper'

class FormBuilderTest < ActionView::TestCase
  def with_custom_form_for(object, *args, &block)
    with_concat_custom_form_for(object) do |f|
      f.input(*args, &block)
    end
  end

  test 'nested simple fields should yield an instance of FormBuilder' do
    simple_form_for :user do |f|
      f.simple_fields_for :posts do |posts_form|
        assert posts_form.instance_of?(SimpleForm::FormBuilder)
      end
    end
  end

  test 'builder input is html safe' do
    simple_form_for @user do |f|
      assert f.input(:name).html_safe?
    end
  end

  test 'builder input should allow a block to configure input' do
    with_form_for @user, :name do
      text_field_tag :foo, :bar, :id => :cool
    end
    assert_no_select 'input.string'
    assert_select 'input#cool'
  end

  test 'builder should allow adding custom input mappings for default input types' do
    swap SimpleForm, :input_mappings => { /count$/ => :integer } do
      with_form_for @user, :post_count
      assert_no_select 'form input#user_post_count.string'
      assert_select 'form input#user_post_count.numeric.integer'
    end
  end

  test 'builder should allow to skip input_type class' do
    swap SimpleForm, :generate_additional_classes_for => [:label, :wrapper] do
      with_form_for @user, :post_count
      assert_no_select "form input#user_post_count.integer"
      assert_select "form input#user_post_count"
    end
  end

  test 'builder should allow adding custom input mappings for integer input types' do
    swap SimpleForm, :input_mappings => { /lock_version/ => :hidden } do
      with_form_for @user, :lock_version
      assert_no_select 'form input#user_lock_version.integer'
      assert_select 'form input#user_lock_version.hidden'
    end
  end

  test 'builder uses the first matching custom input map when more than one matches' do
    swap SimpleForm, :input_mappings => { /count$/ => :integer, /^post_/ => :password } do
      with_form_for @user, :post_count
      assert_no_select 'form input#user_post_count.password'
      assert_select 'form input#user_post_count.numeric.integer'
    end
  end

  test 'builder uses the custom map only for matched attributes' do
    swap SimpleForm, :input_mappings => { /lock_version/ => :hidden } do
      with_form_for @user, :post_count
      assert_no_select 'form input#user_post_count.hidden'
      assert_select 'form input#user_post_count.string'
    end
  end

  # INPUT TYPES
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
    assert_select 'form input#user_age.numeric.integer'
  end

  test 'builder should generate decimal text field for decimal columns' do
    with_form_for @user, :credit_limit
    assert_select 'form input#user_credit_limit.numeric.decimal'
  end

  test 'builder should generate password fields for columns that matches password' do
    with_form_for @user, :password
    assert_select 'form input#user_password.password'
  end

  test 'builder should generate country fields for columns that matches country' do
    with_form_for @user, :residence_country
    assert_select 'form select#user_residence_country.country'
  end

  test 'builder should generate time_zone fields for columns that matches time_zone' do
    with_form_for @user, :time_zone
    assert_select 'form select#user_time_zone.time_zone'
  end

  test 'builder should generate email fields for columns that matches email' do
    with_form_for @user, :email
    assert_select 'form input#user_email.string.email'
  end

  test 'builder should generate tel fields for columns that matches phone' do
    with_form_for @user, :phone_number
    assert_select 'form input#user_phone_number.string.tel'
  end

  test 'builder should generate url fields for columns that matches url' do
    with_form_for @user, :url
    assert_select 'form input#user_url.string.url'
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

  test 'builder should generate file for file columns' do
    @user.avatar = mock("file")
    @user.avatar.expects(:respond_to?).with(:mounted_as).returns(false)
    @user.avatar.expects(:respond_to?).with(:file?).returns(false)
    @user.avatar.expects(:respond_to?).with(:public_filename).returns(true)

    with_form_for @user, :avatar
    assert_select 'form input#user_avatar.file'
  end

  test 'builder should generate file for attributes that are real db columns but have file methods' do
    @user.home_picture = mock("file")
    @user.home_picture.expects(:respond_to?).with(:mounted_as).returns(true)

    with_form_for @user, :home_picture
    assert_select 'form input#user_home_picture.file'
  end

  test 'build should generate select if a collection is given' do
    with_form_for @user, :age, :collection => 1..60
    assert_select 'form select#user_age.select'
  end

  test 'builder should allow overriding default input type for text' do
    with_form_for @user, :name, :as => :text
    assert_no_select 'form input#user_name'
    assert_select 'form textarea#user_name.text'

    with_form_for @user, :active, :as => :radio_buttons
    assert_no_select 'form input[type=checkbox]'
    assert_select 'form input.radio_buttons[type=radio]', :count => 2

    with_form_for @user, :born_at, :as => :string
    assert_no_select 'form select'
    assert_select 'form input#user_born_at.string'
  end

  # COMMON OPTIONS
  test 'builder should add chosen form class' do
    swap SimpleForm, :form_class => :my_custom_class do
      with_form_for @user, :name
      assert_select 'form.my_custom_class'
    end
  end

  test 'builder should allow passing options to input' do
    with_form_for @user, :name, :input_html => { :class => 'my_input', :id => 'my_input' }
    assert_select 'form input#my_input.my_input.string'
  end

  test 'builder should not propagate input options to wrapper' do
    with_form_for @user, :name, :input_html => { :class => 'my_input', :id => 'my_input' }
    assert_no_select 'form div.input.my_input.string'
    assert_select 'form input#my_input.my_input.string'
  end

  test 'builder should generate a input with label' do
    with_form_for @user, :name
    assert_select 'form label.string[for=user_name]', /Name/
  end

  test 'builder should be able to disable the label for a input' do
    with_form_for @user, :name, :label => false
    assert_no_select 'form label'
  end

  test 'builder should use custom label' do
    with_form_for @user, :name, :label => 'Yay!'
    assert_select 'form label', /Yay!/
  end

  test 'builder should pass options to label' do
    with_form_for @user, :name, :label_html => { :id => "cool" }
    assert_select 'form label#cool', /Name/
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

  test 'builder should pass options to hint' do
    with_form_for @user, :name, :hint => 'test', :hint_html => { :id => "cool" }
    assert_select 'span.hint#cool', 'test'
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

  test 'builder should pass options to errors' do
    with_form_for @user, :name, :error_html => { :id => "cool" }
    assert_select 'span.error#cool', "can't be blank"
  end

  test 'placeholder should not be generated when set to false' do
    store_translations(:en, :simple_form => { :placeholders => { :user => {
      :name => 'Name goes here'
    } } }) do
      with_form_for @user, :name, :placeholder => false
      assert_no_select 'input[placeholder]'
    end
  end

  # DEFAULT OPTIONS
  test 'builder should receive a default argument and pass it to the inputs' do
    with_concat_form_for @user, :defaults => { :input_html => { :class => 'default_class' } } do |f|
      f.input :name
    end
    assert_select 'input.default_class'
  end

  test 'builder should receive a default argument and pass it to the inputs, respecting the specific options' do
    with_concat_form_for @user, :defaults => { :input_html => { :class => 'default_class' } } do |f|
      f.input :name, :input_html => { :id => 'specific_id' }
    end
    assert_select 'input.default_class#specific_id'
  end

  test 'builder should receive a default argument and pass it to the inputs, overwriting the defaults with specific options' do
    with_concat_form_for @user, :defaults => { :input_html => { :class => 'default_class', :id => 'default_id' } } do |f|
      f.input :name, :input_html => { :id => 'specific_id' }
    end
    assert_select 'input.default_class#specific_id'
  end

  test 'builder should receive a default argument and pass it to the inputs without changing the defaults' do
    with_concat_form_for @user, :defaults => { :input_html => { :class => 'default_class', :id => 'default_id' } } do |f|
      concat(f.input :name)
      concat(f.input :credit_limit)
    end

    assert_select "input.string.default_class[name='user[name]']"
    assert_no_select "input.string[name='user[credit_limit]']"
  end

  # WITHOUT OBJECT
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

  # CUSTOM FORM BUILDER
  test 'custom builder should inherit mappings' do
    with_custom_form_for @user, :email
    assert_select 'form input[type=email]#user_email.custom'
  end

  test 'form with CustomMapTypeFormBuilder should use custom map type builder' do
    with_concat_custom_mapping_form_for(:user) do |user|
      assert user.instance_of?(CustomMapTypeFormBuilder)
    end
  end

  test 'form with CustomMapTypeFormBuilder should use custom mapping' do
    with_concat_custom_mapping_form_for(:user) do |user|
      assert_equal SimpleForm::Inputs::StringInput, user.class.mappings[:custom_type]
    end
  end

  test 'form without CustomMapTypeFormBuilder should not use custom mapping' do
    with_concat_form_for(:user) do |user|
      assert_nil user.class.mappings[:custom_type]
    end
  end
end
