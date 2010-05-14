require 'test_helper'

class LabelTest < ActionView::TestCase

  setup do
    SimpleForm::Inputs::Base.reset_i18n_cache :translate_required_html
  end

  def with_label_for(object, attribute_name, type, options={})
    concat(simple_form_for object do |f|
      f.attribute_name = attribute_name
      f.reflection     = Association.new(Company, :company, {}) if options.delete(:setup_association)
      f.input_type     = type
      f.options        = options

      concat(SimpleForm::Inputs::Base.new(f).label)
    end)
  end

  test 'label should generate a default humanized description' do
    with_label_for @user, :name, :string
    assert_select 'label[for=user_name]', /Name/
  end

  test 'label should allow a customized description' do
    with_label_for @user, :name, :string, :label => 'My label!'
    assert_select 'label[for=user_name]', /My label!/
  end

  test 'label should use human attribute name from object when available' do
    with_label_for @user, :description, :text
    assert_select 'label[for=user_description]', /User Description!/
  end

  test 'label should use human attribute name based on association name' do
    with_label_for @user, :company_id, :string, :setup_association => true
    assert_select 'label', /Company Human Name!/
  end

  test 'label should use i18n based on model, action, and attribute to lookup translation' do
    @controller.action_name = "new"
    store_translations(:en, :simple_form => { :labels => { :user => {
      :new => { :description => 'Nova descrição' }
    } } } ) do
      with_label_for @user, :description, :text
      assert_select 'label[for=user_description]', /Nova descrição/
    end
  end

  test 'label should fallback to new when action is create' do
    @controller.action_name = "create"
    store_translations(:en, :simple_form => { :labels => { :user => {
      :new => { :description => 'Nova descrição' }
    } } } ) do
      with_label_for @user, :description, :text
      assert_select 'label[for=user_description]', /Nova descrição/
    end
  end

  test 'label should use i18n based on model and attribute to lookup translation' do
    store_translations(:en, :simple_form => { :labels => { :user => {
      :description => 'Descrição'
    } } } ) do
      with_label_for @user, :description, :text
      assert_select 'label[for=user_description]', /Descrição/
    end
  end

  test 'input should use i18n based only on attribute to lookup translation' do
    store_translations(:en, :simple_form => { :labels => { :age => 'Idade' } } ) do
      with_label_for @user, :age, :integer
      assert_select 'label[for=user_age]', /Idade/
    end
  end

  test 'label should use i18n with lookup for association name' do
    store_translations(:en, :simple_form => { :labels => {
      :user => { :company => 'My company!' }
    } } ) do
      with_label_for @user, :company_id, :string, :setup_association => true
      assert_select 'label[for=user_company_id]', /My company!/
    end
  end

  test 'label should have css class from type' do
    with_label_for @user, :name, :string
    assert_select 'label.string'
    with_label_for @user, :description, :text
    assert_select 'label.text'
    with_label_for @user, :age, :integer
    assert_select 'label.integer'
    with_label_for @user, :born_at, :date
    assert_select 'label.date'
    with_label_for @user, :created_at, :datetime
    assert_select 'label.datetime'
  end
  
  test 'label should obtain required from ActiveModel::Validations when it is included' do
    with_label_for @validating_user, :name, :string
    assert_select 'label.required'
    with_label_for @validating_user, :status, :string
    assert_select 'label.optional'
  end
  
  test 'label should allow overriding required when ActiveModel::Validations is included' do
    with_label_for @validating_user, :name, :string, :required => false
    assert_select 'label.optional'
    with_label_for @validating_user, :status, :string, :required => true
    assert_select 'label.required'
  end

  test 'label should be required by default when ActiveModel::Validations is not included' do
    with_label_for @user, :name, :string
    assert_select 'label.required'
  end

  test 'label should be able to disable required when ActiveModel::Validations is not included' do
    with_label_for @user, :name, :string, :required => false
    assert_no_select 'label.required'
  end

  test 'label should add required text when required' do
    with_label_for @user, :name, :string
    assert_select 'label.required abbr[title=required]', '*'
  end

  test 'label should not have required text in no required inputs' do
    with_label_for @user, :name, :string, :required => false
    assert_no_select 'form label abbr'
  end

  test 'label should use i18n to find required text' do
    store_translations(:en, :simple_form => { :required => { :text => 'campo requerido' }}) do
      with_label_for @user, :name, :string
      assert_select 'form label abbr[title=campo requerido]', '*'
    end
  end

  test 'label should use i18n to find required mark' do
    store_translations(:en, :simple_form => { :required => { :mark => '*-*' }}) do
      with_label_for @user, :name, :string
      assert_select 'form label abbr', '*-*'
    end
  end

  test 'label should use i18n to find required string tag' do
    store_translations(:en, :simple_form => { :required => { :html => '<span class="required" title="requerido">*</span>' }}) do
      with_label_for @user, :name, :string
      assert_no_select 'form label abbr'
      assert_select 'form label span.required[title=requerido]', '*'
    end
  end

  test 'label should allow overwriting input id' do
    with_label_for @user, :name, :string, :input_html => { :id => 'my_new_id' }
    assert_select 'label[for=my_new_id]'
  end

  test 'label should use default input id when it was not overridden' do
    with_label_for @user, :name, :string, :input_html => { :class => 'my_new_id' }
    assert_select 'label[for=user_name]'
  end

  test 'label should be generated properly when object is not present' do
    with_label_for :project, :name, :string
    assert_select 'label[for=project_name]', /Name/
  end

  test 'label should use i18n properly when object is not present' do
    store_translations(:en, :simple_form => { :labels => {
      :project => { :name => 'Nome' }
    } } ) do
      with_label_for :project, :name, :string
      assert_select 'label[for=project_name]', /Nome/
    end
  end

  test 'label should add required by default when object is not present' do
    with_label_for :project, :name, :string
    assert_select 'label.required[for=project_name]'
    with_label_for :project, :description, :string, :required => false
    assert_no_select 'label.required[for=project_description]'
  end
end
