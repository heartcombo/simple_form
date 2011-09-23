# encoding: UTF-8
require 'test_helper'

class FormBuilderTest < ActionView::TestCase

  def with_form_for(object, *args, &block)
    with_concat_form_for(object) do |f|
      f.input(*args, &block)
    end
  end

  def with_custom_form_for(object, *args, &block)
    with_concat_custom_form_for(object) do |f|
      f.input(*args, &block)
    end
  end

  def with_button_for(object, *args)
    with_concat_form_for(object) do |f|
      f.button(*args)
    end
  end

  def with_error_for(object, *args)
    with_concat_form_for(object) do |f|
      f.error(*args)
    end
  end

  def with_full_error_for(object, *args)
    with_concat_form_for(object) do |f|
      f.full_error(*args)
    end
  end

  def with_hint_for(object, *args)
    with_concat_form_for(object) do |f|
      f.hint(*args)
    end
  end

  def with_label_for(object, *args, &block)
    with_concat_form_for(object) do |f|
      f.label(*args, &block)
    end
  end

  def with_association_for(object, *args)
    with_concat_form_for(object) do |f|
      f.association(*args)
    end
  end

  # All
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

    with_form_for @user, :active, :as => :radio
    assert_no_select 'form input[type=checkbox]'
    assert_select 'form input.radio[type=radio]', :count => 2

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

  # REQUIRED AND PRESENCE VALIDATION
  test 'builder input should obtain required from ActiveModel::Validations when it is included' do
    with_form_for @validating_user, :name
    assert_select 'input.required[required]#validating_user_name'
    with_form_for @validating_user, :status
    assert_select 'input.optional#validating_user_status'
  end

  test 'builder input should allow overriding required when ActiveModel::Validations is included' do
    with_form_for @validating_user, :name, :required => false
    assert_select 'input.optional#validating_user_name'
    with_form_for @validating_user, :status, :required => true
    assert_select 'input.required[required]#validating_user_status'
  end

  test 'builder input should be required by default when ActiveModel::Validations is not included' do
    with_form_for @user, :name
    assert_select 'input.required[required]#user_name'
  end

  test 'builder input should not be required by default when ActiveModel::Validations is not included if option is set to false' do
    swap SimpleForm, :required_by_default => false do
      with_form_for @user, :name
      assert_select 'input.optional#user_name'
      assert_no_select 'input[required]'
    end
  end

  test 'builder input should allow disabling required when ActiveModel::Validations is not included' do
    with_form_for @user, :name, :required => false
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#user_name'
  end

  # VALIDATORS :if :unless

  test 'builder input should not be required when ActiveModel::Validations is included and if option is present' do
    with_form_for @validating_user, :age
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#validating_user_age'
  end

  test 'builder input should not be required when ActiveModel::Validations is included and unless option is present' do
    with_form_for @validating_user, :amount
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#validating_user_amount'
  end

  # VALIDATORS :on

  test 'builder input should be required when validation is on create and is not persisted' do
    @validating_user.new_record!
    with_form_for @validating_user, :action
    assert_select 'input.required'
    assert_select 'input[required]'
    assert_select 'input.required[required]#validating_user_action'
  end

  test 'builder input should not be required when validation is on create and is persisted' do
    with_form_for @validating_user, :action
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#validating_user_action'
  end

  test 'builder input should be required when validation is on save' do
    with_form_for @validating_user, :credit_limit
    assert_select 'input.required'
    assert_select 'input[required]'
    assert_select 'input.required[required]#validating_user_credit_limit'

    @validating_user.new_record!
    with_form_for @validating_user, :credit_limit
    assert_select 'input.required'
    assert_select 'input[required]'
    assert_select 'input.required[required]#validating_user_credit_limit'
  end

  test 'builder input should be required when validation is on update and is persisted' do
    with_form_for @validating_user, :phone_number
    assert_select 'input.required'
    assert_select 'input[required]'
    assert_select 'input.required[required]#validating_user_phone_number'
  end

  test 'builder input should not be required when validation is on update and is not persisted' do
    @validating_user.new_record!
    with_form_for @validating_user, :phone_number
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#validating_user_phone_number'
  end

  # WRAPPERS

  test 'builder support wrapping around an specific tag' do
    swap SimpleForm, :wrapper_tag => :p do
      with_form_for @user, :name
      assert_select 'form p label[for=user_name]'
      assert_select 'form p input#user_name.string'
    end
  end

  test 'builder support no wrapping when wrapper is false' do
    with_form_for @user, :name, :wrapper => false
    assert_select 'form > label[for=user_name]'
    assert_select 'form > input#user_name.string'
  end

  test 'builder wrapping tag adds default css classes' do
    swap SimpleForm, :wrapper_tag => :p do
      with_form_for @user, :name
      assert_select 'form p.input.required.string'

      with_form_for @user, :age, :required => false
      assert_select 'form p.input.optional.integer'
    end
  end

  test 'builder wrapping tag allow custom options to be given' do
    swap SimpleForm, :wrapper_tag => :p do
      with_form_for @user, :name, :wrapper_html => { :id => "super_cool", :class => 'yay' }
      assert_select 'form p#super_cool.required.string.yay'
    end
  end

  test 'builder allows wrapper tag to be given on demand' do
    with_concat_form_for(@user) do |f|
      f.input :name, :wrapper_tag => :b
    end
    assert_select 'form b.required.string'
  end

  test 'builder allows wrapper class to be given on demand' do
    with_concat_form_for(@user) do |f|
      f.input :name, :wrapper_class => :wrapper
    end
    assert_select 'form div.wrapper.required.string'
  end

  test 'builder wrapping tag adds errors class for attribute with errors' do
    with_form_for @user, :name
    assert_select 'form div.input.required.string.field_with_errors'
  end

  # ONLY THE INPUT TAG
  test "builder input_field should only render the input tag, nothing else" do
    with_concat_form_for(@user) do |f|
      f.input_field :name
    end
    assert_select 'form > input.required.string'
    assert_no_select 'div.string'
    assert_no_select 'label'
    assert_no_select '.hint'
  end

  test 'builder input_field should allow overriding default input type' do
    with_concat_form_for(@user) do |f|
      f.input_field :name, :as => :text
    end

    assert_no_select 'input#user_name'
    assert_select 'textarea#user_name.text'
  end

  test 'builder input_field should allow passing options to input tag' do
    with_concat_form_for(@user) do |f|
      f.input_field :name, :id => 'name_input', :class => 'name'
    end

    assert_select 'input.string.name#name_input'
  end

  test 'builder input_field should generate an input tag with a clean HTML' do
    with_concat_form_for(@user) do |f|
      f.input_field :name, :as => :integer, :class => 'name'
    end

    assert_no_select 'input.integer[input_html]'
    assert_no_select 'input.integer[as]'
  end

  test 'builder collection input_field should generate input tag with a clean HTML' do
    with_concat_form_for(@user) do |f|
      f.input_field :status, :collection => ['Open', 'Closed'], :class => 'status', :label_method => :to_s, :value_method => :to_s
    end

    assert_no_select 'select.status[input_html]'
    assert_no_select 'select.status[collection]'
    assert_no_select 'select.status[label_method]'
    assert_no_select 'select.status[value_method]'
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

  # ERRORS
  test 'builder should generate an error tag for the attribute' do
    with_error_for @user, :name
    assert_select 'span.error', "can't be blank"
  end

  test 'builder should generate an error tag with a clean HTML' do
    with_error_for @user, :name
    assert_no_select 'span.error[error_html]'
  end

  test 'builder should generate an error tag with a clean HTML when errors options are present' do
    with_error_for @user, :name, :error_tag => :p, :error_prefix => 'Name', :error_method => :first
    assert_no_select 'p.error[error_html]'
    assert_no_select 'p.error[error_tag]'
    assert_no_select 'p.error[error_prefix]'
    assert_no_select 'p.error[error_method]'
  end

  test 'builder should allow passing options to error tag' do
    with_error_for @user, :name, :id => 'name_error'
    assert_select 'span.error#name_error', "can't be blank"
  end

  # FULL ERRORS
  test 'builder should generate an full error tag for the attribute' do
    with_full_error_for @user, :name
    assert_select 'span.error', "Super User Name! can't be blank"
  end

  test 'builder should generate an full  error tag with a clean HTML' do
    with_full_error_for @user, :name
    assert_no_select 'span.error[error_html]'
  end

  test 'builder should allow passing options to full error tag' do
    with_full_error_for @user, :name, :id => 'name_error', :error_prefix => "Your name"
    assert_select 'span.error#name_error', "Your name can't be blank"
  end

  # HINTS
  test 'builder should generate a hint tag for the attribute' do
    store_translations(:en, :simple_form => { :hints => { :user => { :name => "Add your name" }}}) do
      with_hint_for @user, :name
      assert_select 'span.hint', 'Add your name'
    end
  end

  test 'builder should generate a hint component tag for the given text for a model with ActiveModel::Validations' do
    with_hint_for @validating_user, 'Hello World!'
    assert_select 'span.hint', 'Hello World!'
  end

  test 'builder should generate a hint component tag for the given text' do
    with_hint_for @user, 'Hello World!'
    assert_select 'span.hint', 'Hello World!'
  end

  test 'builder should generate a hint componet tag with a clean HTML' do
    with_hint_for @validating_user, 'Hello World!'
    assert_no_select 'span.hint[hint]'
    assert_no_select 'span.hint[hint_html]'
  end

  test 'builder should generate a hint componet tag with a clean HTML when hint_tag option is present' do
    with_hint_for @user, 'Hello World!', :hint_tag => :p
    assert_no_select 'p.hint[hint]'
    assert_no_select 'p.hint[hint_html]'
    assert_no_select 'p.hint[hint_tag]'
  end

  test 'builder should allow passing options to hint tag' do
    with_hint_for @user, :name, :hint => 'Hello World!', :id => 'name_hint'
    assert_select 'span.hint#name_hint', 'Hello World!'
  end

  # LABELS
  test 'builder should generate a label for the attribute' do
    with_label_for @user, :name
    assert_select 'label.string[for=user_name]', /Name/
  end

  test 'builder should generate a label componet tag with a clean HTML' do
    with_label_for @user, :name
    assert_no_select 'label.string[label_html]'
  end

  test 'builder should add a required class to label if the attribute is required' do
    with_label_for @validating_user, :name
    assert_select 'label.string.required[for=validating_user_name]', /Name/
  end

  test 'builder should allow passing options to label tag' do
    with_label_for @user, :name, :label => 'My label', :id => 'name_label'
    assert_select 'label.string#name_label', /My label/
  end

  test 'builder should fallback to default label when string is given' do
    with_label_for @user, :name, 'Nome do usuário'
    assert_select 'label', 'Nome do usuário'
    assert_no_select 'label.string'
  end

  test 'builder should fallback to default label when block is given' do
    with_label_for @user, :name do
      'Nome do usuário'
    end
    assert_select 'label', 'Nome do usuário'
    assert_no_select 'label.string'
  end

  test 'builder allows label order to be changed' do
    swap SimpleForm, :label_text => lambda { |l, r| "#{l}:" } do
      with_label_for @user, :age
      assert_select 'label.integer[for=user_age]', "Age:"
    end
  end

  # BUTTONS
  test 'builder should create buttons' do
    with_button_for :post, :submit
    assert_select 'form input.button[type=submit][value=Save Post]'
  end

  test 'builder should create buttons for records' do
    @user.new_record!
    with_button_for @user, :submit
    assert_select 'form input.button[type=submit][value=Create User]'
  end

  # ASSOCIATIONS
  test 'builder should not allow creating an association input when no object exists' do
    assert_raise ArgumentError do
      with_association_for :post, :author
    end
  end

  test 'builder association with a block calls simple_fields_for' do
    simple_form_for @user do |f|
      f.association :posts do |posts_form|
        assert posts_form.instance_of?(SimpleForm::FormBuilder)
      end
    end
  end

  test 'builder association forwards collection to simple_fields_for' do
    calls = 0
    simple_form_for @user do |f|
      f.association :company, :collection => Company.all do |c|
        calls += 1
      end
    end

    assert_equal 3, calls
  end

  test 'builder association marks input as required based on both association and attribute' do
    swap SimpleForm, :required_by_default => false do
      with_association_for @validating_user, :company, :collection => []
      assert_select 'label.required'
    end
  end

  test 'builder preloads collection association' do
    value = @user.tags
    value.expects(:to_a).returns(value)
    with_association_for @user, :tags
    assert_select 'form select.select#user_tag_ids'
    assert_select 'form select option[value=1]', 'Tag 1'
    assert_select 'form select option[value=2]', 'Tag 2'
    assert_select 'form select option[value=3]', 'Tag 3'
  end

  test 'builder does not preload collection association if preload is false' do
    value = @user.company
    value.expects(:to_a).never
    with_association_for @user, :company, :preload => false
    assert_select 'form select.select#user_company_id'
    assert_select 'form select option[value=1]', 'Company 1'
    assert_select 'form select option[value=2]', 'Company 2'
    assert_select 'form select option[value=3]', 'Company 3'
  end

  test 'builder does not preload non-collection association' do
    value = @user.company
    value.expects(:to_a).never
    with_association_for @user, :company, :preload => false
    assert_select 'form select.select#user_company_id'
    assert_select 'form select option[value=1]', 'Company 1'
    assert_select 'form select option[value=2]', 'Company 2'
    assert_select 'form select option[value=3]', 'Company 3'
  end

  # ASSOCIATIONS - BELONGS TO
  test 'builder creates a select for belongs_to associations' do
    with_association_for @user, :company
    assert_select 'form select.select#user_company_id'
    assert_select 'form select option[value=1]', 'Company 1'
    assert_select 'form select option[value=2]', 'Company 2'
    assert_select 'form select option[value=3]', 'Company 3'
  end

  test 'builder allows collection radio for belongs_to associations' do
    with_association_for @user, :company, :as => :radio
    assert_select 'form input.radio#user_company_id_1'
    assert_select 'form input.radio#user_company_id_2'
    assert_select 'form input.radio#user_company_id_3'
  end

  test 'builder marks the record which already belongs to the user' do
    @user.company_id = 2
    with_association_for @user, :company, :as => :radio
    assert_no_select 'form input.radio#user_company_id_1[checked=checked]'
    assert_select 'form input.radio#user_company_id_2[checked=checked]'
    assert_no_select 'form input.radio#user_company_id_3[checked=checked]'
  end

  # ASSOCIATIONS - FINDERS
  test 'builder should use reflection conditions to find collection' do
    with_association_for @user, :special_company
    assert_select 'form select.select#user_special_company_id'
    assert_select 'form select option[value=1]'
    assert_no_select 'form select option[value=2]'
    assert_no_select 'form select option[value=3]'
  end

  test 'builder should allow overriding collection to association input' do
    with_association_for @user, :company, :include_blank => false,
                         :collection => [Company.new(999, 'Teste')]
    assert_select 'form select.select#user_company_id'
    assert_no_select 'form select option[value=1]'
    assert_select 'form select option[value=999]', 'Teste'
    assert_select 'form select option', :count => 1
  end

  # ASSOCIATIONS - has_*
  test 'builder does not allow has_one associations' do
    assert_raise RuntimeError do
      with_association_for @user, :first_company, :as => :radio
    end
  end

  test 'builder creates a select with multiple options for collection associations' do
    with_association_for @user, :tags
    assert_select 'form select.select#user_tag_ids'
    assert_select 'form select[multiple=multiple][size=5]'
    assert_select 'form select option[value=1]', 'Tag 1'
    assert_select 'form select option[value=2]', 'Tag 2'
    assert_select 'form select option[value=3]', 'Tag 3'
  end

  test 'builder allows size to be overwritten for collection associations' do
    with_association_for @user, :tags, :input_html => { :size => 10 }
    assert_select 'form select[multiple=multiple][size=10]'
  end

  test 'builder marks all selected records which already belongs to user' do
    @user.tag_ids = [1, 2]
    with_association_for @user, :tags
    assert_select 'form select option[value=1][selected=selected]'
    assert_select 'form select option[value=2][selected=selected]'
    assert_no_select 'form select option[value=3][selected=selected]'
  end

  test 'builder allows a collection of check boxes for collection associations' do
    @user.tag_ids = [1, 2]
    with_association_for @user, :tags, :as => :check_boxes
    assert_select 'form input#user_tag_ids_1[type=checkbox]'
    assert_select 'form input#user_tag_ids_2[type=checkbox]'
    assert_select 'form input#user_tag_ids_3[type=checkbox]'
  end

  test 'builder marks all selected records for collection boxes' do
    @user.tag_ids = [1, 2]
    with_association_for @user, :tags, :as => :check_boxes
    assert_select 'form input[type=checkbox][value=1][checked=checked]'
    assert_select 'form input[type=checkbox][value=2][checked=checked]'
    assert_no_select 'form input[type=checkbox][value=3][checked=checked]'
  end

  test 'builder with collection support giving collection and item wrapper tags' do
    with_association_for @user, :tags, :as => :check_boxes,
      :collection_wrapper_tag => :ul, :item_wrapper_tag => :li

    assert_select 'form ul', :count => 1
    assert_select 'form ul li', :count => 3
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

  # DISCOVERY
  # Setup new inputs and remove them after the test.
  def discovery(value=false)
    swap SimpleForm, :cache_discovery => value do
      begin
        load "discovery_inputs.rb"
        yield
      ensure
        SimpleForm::FormBuilder.discovery_cache.clear
        Object.send :remove_const, :StringInput
        Object.send :remove_const, :NumericInput
        Object.send :remove_const, :CustomizedInput
      end
    end
  end

  test 'builder should not discover new inputs if cached' do
    with_form_for @user, :name
    assert_select 'form input#user_name.string'

    discovery(true) do
      with_form_for @user, :name
      assert_no_select 'form section input#user_name.string'
    end
  end

  test 'builder should discover new inputs' do
    discovery do
      with_form_for @user, :name, :as => :customized
      assert_select 'form section input#user_name.string'
    end
  end

  test 'builder should not discover new inputs if discovery is off' do
    with_form_for @user, :name
    assert_select 'form input#user_name.string'

    swap SimpleForm, :inputs_discovery => false do
      discovery do
        with_form_for @user, :name
        assert_no_select 'form section input#user_name.string'
      end
    end
  end

  test 'builder should discover new inputs from mappings if not cached' do
    discovery do
      with_form_for @user, :name
      assert_select 'form section input#user_name.string'
    end
  end

  test 'builder should discover new inputs from internal fallbacks if not cached' do
    discovery do
      with_form_for @user, :age
      assert_select 'form section input#user_age.numeric.integer'
    end
  end

  # CUSTOM COMPONENTS
  # Setup new components and remove them after the test.
  def custom_component(components=[:label_input, :div])
    swap SimpleForm, :components => components do
      begin
        load "custom_components.rb"
        yield
      ensure
        Div.send(:undef_method, :div)
        Object.send :remove_const, :Div
      end
    end
  end

  test 'builder should accept new components' do
    custom_component do
      with_form_for @user, :age
      assert_select 'form input#user_age.numeric.integer'
      assert_select 'form .custom_input'
    end
  end

  test 'input field should render only the input' do
    custom_component do
      with_concat_form_for(@user) do |f|
        f.input_field :age
      end

      assert_select 'form input#user_age.numeric.integer'
      assert_no_select 'form .custom_input'
    end
  end
end
