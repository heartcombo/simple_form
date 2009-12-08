require 'test_helper'

class LabelTest < ActionView::TestCase

  test 'input should generate a label with the text field' do
    simple_form_for @user do |f|
      concat f.input :name
    end
    assert_select 'form label[for=user_name]', /Name/
  end

  test 'input should allow not using a label' do
    simple_form_for @user do |f|
      concat f.input :name, :label => false
    end
    assert_no_select 'label'
  end

  test 'input should allow using a customized label' do
    simple_form_for @user do |f|
      concat f.input :name, :label => 'My label!'
    end
    assert_select 'form label[for=user_name]', /My label!/
  end

  test 'input should use label with human attribute name if it responds to it' do
    @super_user = SuperUser.new
    simple_form_for @super_user do |f|
      concat f.input :name
    end
    assert_select 'form label[for=super_user_name]', /Super User Name!/
  end

  test 'input should use i18n to pick up label translation' do
    store_translations(:en, :views => { :labels => { :super_user => {
      :description => 'Descrição', :age => 'Idade'
    } } } ) do
      @super_user = SuperUser.new
      simple_form_for @super_user do |f|
        concat f.input :description
        concat f.input :age
      end
      assert_select 'form label[for=super_user_description]', /Descrição/
      assert_select 'form label[for=super_user_age]', /Idade/
    end
  end

  test 'label should use the same css class as input' do
    simple_form_for @user do |f|
      concat f.input :name
      concat f.input :description
      concat f.input :created_at
      concat f.input :born_at
      concat f.input :active
      concat f.input :age
      concat f.input :credit_limit
    end
    assert_select 'form label.string[for=user_name]'
    assert_select 'form label.text[for=user_description]'
    assert_select 'form label.datetime[for=user_created_at]'
    assert_select 'form label.date[for=user_born_at]'
    assert_select 'form label.boolean[for=user_active]'
    assert_select 'form label.integer[for=user_age]'
    assert_select 'form label.numeric[for=user_credit_limit]'
  end

  test 'input required should generate label required as well' do
    simple_form_for @user do |f|
      concat f.input :name
    end
    assert_select 'form label.required'
  end

  test 'input not required should not generate label required' do
    simple_form_for @user do |f|
      concat f.input :name, :required => false
    end
    assert_no_select 'form label.required'
  end

  test 'label should add required text when input is required' do
    simple_form_for @user do |f|
      concat f.input :name
    end
    assert_select 'form label.required', '* Name'
    assert_select 'form label abbr[title=required]', '*'
  end

  test 'label should not have required text in no required inputs' do
    simple_form_for @user do |f|
      concat f.input :name, :required => false
    end
    assert_no_select 'form label abbr'
  end

  test 'label should use i18n to find required text' do
    store_translations(:en, :simple_form => { :required_text => 'campo requerido' }) do
      simple_form_for @user do |f|
        concat f.input :name
      end
      assert_select 'form label abbr[title=campo requerido]', '*'
    end
  end

  test 'label should use i18n to find required mark' do
    store_translations(:en, :simple_form => { :required_mark => '*-*' }) do
      simple_form_for @user do |f|
        concat f.input :name
      end
      assert_select 'form label abbr', '*-*'
    end
  end

  test 'label should use i18n to find required string tag' do
    store_translations(:en, :simple_form => { :required_string => '<span class="required" title="requerido">*</span>' }) do
      simple_form_for @user do |f|
        concat f.input :name
      end
      assert_no_select 'form label abbr'
      assert_select 'form label span.required[title=requerido]', '*'
    end
  end
end
