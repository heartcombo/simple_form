# encoding: UTF-8
require 'test_helper'

class CollectionSelectInputTest < ActionView::TestCase
  setup do
    SimpleForm::Inputs::CollectionSelectInput.reset_i18n_cache :boolean_collection
  end

  test 'input should generate a boolean select with options by default for select types' do
    with_input_for @user, :active, :select
    assert_select 'select.select#user_active'
    assert_select 'select option[value=true]', 'Yes'
    assert_select 'select option[value=false]', 'No'
  end

  test 'input as select should use i18n to translate select boolean options' do
    store_translations(:en, :simple_form => { :yes => 'Sim', :no => 'Não' }) do
      with_input_for @user, :active, :select
      assert_select 'select option[value=true]', 'Sim'
      assert_select 'select option[value=false]', 'Não'
    end
  end

  test 'input should allow overriding collection for select types' do
    with_input_for @user, :name, :select, :collection => ['Jose', 'Carlos']
    assert_select 'select.select#user_name'
    assert_select 'select option', 'Jose'
    assert_select 'select option', 'Carlos'
  end

  test 'input should do automatic collection translation for select types using defaults key' do
    store_translations(:en, :simple_form => { :options => { :defaults => {
      :gender => { :male => 'Male', :female => 'Female'}
    } } } ) do
      with_input_for @user, :gender, :select, :collection => [:male, :female]
      assert_select 'select.select#user_gender'
      assert_select 'select option', 'Male'
      assert_select 'select option', 'Female'
    end
  end

  test 'input should do automatic collection translation for select types using specific object key' do
    store_translations(:en, :simple_form => { :options => { :user => {
      :gender => { :male => 'Male', :female => 'Female'}
    } } } ) do
      with_input_for @user, :gender, :select, :collection => [:male, :female]
      assert_select 'select.select#user_gender'
      assert_select 'select option', 'Male'
      assert_select 'select option', 'Female'
    end
  end

  test 'input should mark the selected value by default' do
    @user.name = "Carlos"
    with_input_for @user, :name, :select, :collection => ['Jose', 'Carlos']
    assert_select 'select option[selected=selected]', 'Carlos'
  end

  test 'input should mark the selected value also when using integers' do
    @user.age = 18
    with_input_for @user, :age, :select, :collection => 18..60
    assert_select 'select option[selected=selected]', '18'
  end

  test 'input should mark the selected value when using booleans and select' do
    @user.active = false
    with_input_for @user, :active, :select
    assert_no_select 'select option[selected][value=true]', 'Yes'
    assert_select 'select option[selected][value=false]', 'No'
  end

  test 'input should set the correct value when using a collection that includes floats' do
    with_input_for @user, :age, :select, :collection => [2.0, 2.5, 3.0, 3.5, 4.0, 4.5]
    assert_select 'select option[value="2.0"]'
    assert_select 'select option[value="2.5"]'
  end

  test 'input should set the correct values when using a collection that uses mixed values' do
    with_input_for @user, :age, :select, :collection => ["Hello Kitty", 2, 4.5, :johnny, nil, true, false]
    assert_select 'select option[value="Hello Kitty"]'
    assert_select 'select option[value="2"]'
    assert_select 'select option[value="4.5"]'
    assert_select 'select option[value="johnny"]'
    assert_select 'select option[value=""]'
    assert_select 'select option[value="true"]'
    assert_select 'select option[value="false"]'
  end

  test 'input should include a blank option even if :include_blank is set to false if the collection includes a nil value' do
    with_input_for @user, :age, :select, :collection => [nil], :include_blank => false
    assert_select 'select option[value=""]'
  end

  test 'input should automatically set include blank' do
    with_input_for @user, :age, :select, :collection => 18..30
    assert_select 'select option[value=]', ''
  end

  test 'input should not set include blank if otherwise is told' do
    with_input_for @user, :age, :select, :collection => 18..30, :include_blank => false
    assert_no_select 'select option[value=]', ''
  end

  test 'input should not set include blank if prompt is given' do
    with_input_for @user, :age, :select, :collection => 18..30, :prompt => "Please select foo"
    assert_no_select 'select option[value=]', ''
  end

  test 'input should not set include blank if multiple is given' do
    with_input_for @user, :age, :select, :collection => 18..30, :input_html => { :multiple => true }
    assert_no_select 'select option[value=]', ''
  end

  test 'input should detect label and value on collections' do
    users = [ setup_new_user(:id => 1, :name => "Jose"), setup_new_user(:id => 2, :name => "Carlos") ]
    with_input_for @user, :description, :select, :collection => users
    assert_select 'select option[value=1]', 'Jose'
    assert_select 'select option[value=2]', 'Carlos'
  end

  test 'input should disable the anothers components when the option is a object' do
    with_input_for @user, :description, :select, :collection => ["Jose", "Carlos"], :disabled => true
    assert_no_select 'select option[value=Jose][disabled=disabled]', 'Jose'
    assert_no_select 'select option[value=Carlos][disabled=disabled]', 'Carlos'
    assert_select 'select[disabled=disabled]'
    assert_select 'div.disabled'
  end

  test 'input should not disable the anothers components when the option is a object' do
    with_input_for @user, :description, :select, :collection => ["Jose", "Carlos"], :disabled => 'Jose'
    assert_select 'select option[value=Jose][disabled=disabled]', 'Jose'
    assert_no_select 'select option[value=Carlos][disabled=disabled]', 'Carlos'
    assert_no_select 'select[disabled=disabled]'
    assert_no_select 'div.disabled'
  end

  test 'input should allow overriding label and value method using a lambda for collection selects' do
    with_input_for @user, :name, :select,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => lambda { |i| i.upcase },
                          :value_method => lambda { |i| i.downcase }
    assert_select 'select option[value=jose]', "JOSE"
    assert_select 'select option[value=carlos]', "CARLOS"
  end

  test 'input should allow overriding only label but not value method using a lambda for collection select' do
    with_input_for @user, :name, :select,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => lambda { |i| i.upcase }
    assert_select 'select option[value=Jose]', "JOSE"
    assert_select 'select option[value=Carlos]', "CARLOS"
  end

  test 'input should allow overriding only value but not label method using a lambda for collection select' do
    with_input_for @user, :name, :select,
                          :collection => ['Jose' , 'Carlos'],
                          :value_method => lambda { |i| i.downcase }
    assert_select 'select option[value=jose]', "Jose"
    assert_select 'select option[value=carlos]', "Carlos"
  end

  test 'input should allow symbols for collections' do
    with_input_for @user, :name, :select, :collection => [:jose, :carlos]
    assert_select 'select.select#user_name'
    assert_select 'select option[value=jose]', 'jose'
    assert_select 'select option[value=carlos]', 'carlos'
  end

  test 'collection input with select type should generate required html attribute only with blank option' do
    with_input_for @user, :name, :select, :include_blank => true, :collection => ['Jose' , 'Carlos']
    assert_select 'select.required'
    assert_select 'select[required]'
  end

  test 'collection input with select type should not generate required html attribute without blank option' do
    with_input_for @user, :name, :select, :include_blank => false, :collection => ['Jose' , 'Carlos']
    assert_select 'select.required'
    assert_no_select 'select[required]'
  end

  test 'collection input with select type with multiple attribute should generate required html attribute without blank option' do
    with_input_for @user, :name, :select, :include_blank => false, :input_html => {:multiple => true}, :collection => ['Jose' , 'Carlos']
    assert_select 'select.required'
    assert_select 'select[required]'
  end

  test 'collection input with select type with multiple attribute should generate required html attribute with blank option' do
    with_input_for @user, :name, :select, :include_blank => true, :input_html => {:multiple => true}, :collection => ['Jose' , 'Carlos']
    assert_select 'select.required'
    assert_select 'select[required]'
  end

  test 'input should allow disabled options with a lambda for collection select' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :disabled => lambda { |x| x == "Carlos" }
    assert_select 'select option[value=Carlos][disabled=disabled]', 'Carlos'
    assert_select 'select option[value=Antonio]', 'Antonio'
    assert_no_select 'select option[value=Antonio][disabled]'
  end

  test 'input should allow disabled and label method with lambdas for collection select' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :disabled => lambda { |x| x == "Carlos" }, :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][disabled=disabled]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][disabled]'
  end

  test 'input should allow a non lambda disabled option with lambda label method for collections' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :disabled => "Carlos", :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][disabled=disabled]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][disabled]'
  end

  test 'input should allow selected and label method with lambdas for collection select' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :selected => lambda { |x| x == "Carlos" }, :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][selected=selected]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][selected]'
  end

  test 'input should allow a non lambda selected option with lambda label method for collection select' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :selected => "Carlos", :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][selected=selected]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][selected]'
  end

  test 'input should not override default selection through attribute value with label method as lambda for collection select' do
    @user.name = "Carlos"
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][selected=selected]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][selected]'
  end
end
