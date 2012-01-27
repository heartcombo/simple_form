# encoding: UTF-8
require 'test_helper'

class CollectionRadioInputTest < ActionView::TestCase
  setup do
    SimpleForm::Inputs::CollectionRadioInput.reset_i18n_cache :boolean_collection
  end

  test 'input should generate boolean radio buttons by default for radio types' do
    with_input_for @user, :active, :radio
    assert_select 'input[type=radio][value=true].radio#user_active_true'
    assert_select 'input[type=radio][value=false].radio#user_active_false'
  end

  test 'input as radio should generate internal labels by default' do
    with_input_for @user, :active, :radio
    assert_select 'label[for=user_active_true]', 'Yes'
    assert_select 'label[for=user_active_false]', 'No'
  end

  test 'input as radio should use i18n to translate internal labels' do
    store_translations(:en, :simple_form => { :yes => 'Sim', :no => 'Não' }) do
      with_input_for @user, :active, :radio
      assert_select 'label[for=user_active_true]', 'Sim'
      assert_select 'label[for=user_active_false]', 'Não'
    end
  end

  test 'input radio should not include for attribute by default' do
    with_input_for @user, :gender, :radio, :collection => [:male, :female]
    assert_select 'label'
    assert_no_select 'label[for=user_gender]'
  end

  test 'input radio should include for attribute when giving as html option' do
    with_input_for @user, :gender, :radio, :collection => [:male, :female], :label_html => { :for => 'gender' }
    assert_select 'label[for=gender]'
  end

  test 'input should mark the checked value when using boolean and radios' do
    @user.active = false
    with_input_for @user, :active, :radio
    assert_no_select 'input[type=radio][value=true][checked]'
    assert_select 'input[type=radio][value=false][checked]'
  end

  test 'input should allow overriding collection for radio types' do
    with_input_for @user, :name, :radio, :collection => ['Jose', 'Carlos']
    assert_select 'input[type=radio][value=Jose]'
    assert_select 'input[type=radio][value=Carlos]'
    assert_select 'label.collection_radio', 'Jose'
    assert_select 'label.collection_radio', 'Carlos'
  end

  test 'input should do automatic collection translation for radio types using defaults key' do
    store_translations(:en, :simple_form => { :options => { :defaults => {
      :gender => { :male => 'Male', :female => 'Female'}
    } } } ) do
      with_input_for @user, :gender, :radio, :collection => [:male, :female]
      assert_select 'input[type=radio][value=male]'
      assert_select 'input[type=radio][value=female]'
      assert_select 'label.collection_radio', 'Male'
      assert_select 'label.collection_radio', 'Female'
    end
  end

  test 'input should do automatic collection translation for radio types using specific object key' do
    store_translations(:en, :simple_form => { :options => { :user => {
      :gender => { :male => 'Male', :female => 'Female'}
    } } } ) do
      with_input_for @user, :gender, :radio, :collection => [:male, :female]
      assert_select 'input[type=radio][value=male]'
      assert_select 'input[type=radio][value=female]'
      assert_select 'label.collection_radio', 'Male'
      assert_select 'label.collection_radio', 'Female'
    end
  end

  test 'input should mark the current radio value by default' do
    @user.name = "Carlos"
    with_input_for @user, :name, :radio, :collection => ['Jose', 'Carlos']
    assert_select 'input[type=radio][value=Carlos][checked=checked]'
  end

  test 'input should allow using a collection with text/value arrays' do
    with_input_for @user, :name, :radio, :collection => [['Jose', 'jose'], ['Carlos', 'carlos']]
    assert_select 'input[type=radio][value=jose]'
    assert_select 'input[type=radio][value=carlos]'
    assert_select 'label.collection_radio', 'Jose'
    assert_select 'label.collection_radio', 'Carlos'
  end

  test 'input should allow using a collection with a Proc' do
    with_input_for @user, :name, :radio, :collection => Proc.new { ['Jose', 'Carlos' ] }
    assert_select 'label.collection_radio', 'Jose'
    assert_select 'label.collection_radio', 'Carlos'
  end

  test 'input should allow overriding only label method for collections' do
    with_input_for @user, :name, :radio,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => :upcase
    assert_select 'label.collection_radio', 'JOSE'
    assert_select 'label.collection_radio', 'CARLOS'
  end

  test 'input should allow overriding only value method for collections' do
    with_input_for @user, :name, :radio,
                          :collection => ['Jose' , 'Carlos'],
                          :value_method => :upcase
    assert_select 'input[type=radio][value=JOSE]'
    assert_select 'input[type=radio][value=CARLOS]'
  end

  test 'input should allow overriding label and value method for collections' do
    with_input_for @user, :name, :radio,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => :upcase,
                          :value_method => :downcase
    assert_select 'input[type=radio][value=jose]'
    assert_select 'input[type=radio][value=carlos]'
    assert_select 'label.collection_radio', 'JOSE'
    assert_select 'label.collection_radio', 'CARLOS'
  end

  test 'input should allow overriding label and value method using a lambda for collections' do
    with_input_for @user, :name, :radio,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => lambda { |i| i.upcase },
                          :value_method => lambda { |i| i.downcase }
    assert_select 'input[type=radio][value=jose]'
    assert_select 'input[type=radio][value=carlos]'
    assert_select 'label.collection_radio', 'JOSE'
    assert_select 'label.collection_radio', 'CARLOS'
  end

  test 'collection input with radio type should generate required html attribute' do
    with_input_for @user, :name, :radio, :collection => ['Jose' , 'Carlos']
    assert_select 'input[type=radio].required'
    assert_select 'input[type=radio][required]'
  end

  test 'input radio does not wrap the collection by default' do
    with_input_for @user, :active, :radio

    assert_select 'form input[type=radio]', :count => 2
    assert_no_select 'form ul'
  end

  test 'input radio wraps the collection in the configured collection wrapper tag' do
    swap SimpleForm, :collection_wrapper_tag => :ul do
      with_input_for @user, :active, :radio

      assert_select 'form ul input[type=radio]', :count => 2
    end
  end

  test 'input radio does not wrap the collection when configured with falsy values' do
    swap SimpleForm, :collection_wrapper_tag => false do
      with_input_for @user, :active, :radio

      assert_select 'form input[type=radio]', :count => 2
      assert_no_select 'form ul'
    end
  end

  test 'input radio allows overriding the collection wrapper tag at input level' do
    swap SimpleForm, :collection_wrapper_tag => :ul do
      with_input_for @user, :active, :radio, :collection_wrapper_tag => :section

      assert_select 'form section input[type=radio]', :count => 2
      assert_no_select 'form ul'
    end
  end

  test 'input radio allows disabling the collection wrapper tag at input level' do
    swap SimpleForm, :collection_wrapper_tag => :ul do
      with_input_for @user, :active, :radio, :collection_wrapper_tag => false

      assert_select 'form input[type=radio]', :count => 2
      assert_no_select 'form ul'
    end
  end

  test 'input radio renders the wrapper tag with the configured wrapper class' do
    swap SimpleForm, :collection_wrapper_tag => :ul, :collection_wrapper_class => 'inputs-list' do
      with_input_for @user, :active, :radio

      assert_select 'form ul.inputs-list input[type=radio]', :count => 2
    end
  end

  test 'input radio allows giving wrapper class at input level only' do
    swap SimpleForm, :collection_wrapper_tag => :ul do
      with_input_for @user, :active, :radio, :collection_wrapper_class => 'items-list'

      assert_select 'form ul.items-list input[type=radio]', :count => 2
    end
  end

  test 'input radio uses both configured and given wrapper classes for wrapper tag' do
    swap SimpleForm, :collection_wrapper_tag => :ul, :collection_wrapper_class => 'inputs-list' do
      with_input_for @user, :active, :radio, :collection_wrapper_class => 'items-list'

      assert_select 'form ul.inputs-list.items-list input[type=radio]', :count => 2
    end
  end

  test 'input radio wraps each item in the configured item wrapper tag' do
    swap SimpleForm, :item_wrapper_tag => :li do
      with_input_for @user, :active, :radio

      assert_select 'form li input[type=radio]', :count => 2
    end
  end

  test 'input radio does not wrap items when configured with falsy values' do
    swap SimpleForm, :item_wrapper_tag => false do
      with_input_for @user, :active, :radio

      assert_select 'form input[type=radio]', :count => 2
      assert_no_select 'form li'
    end
  end

  test 'input radio allows overriding the item wrapper tag at input level' do
    swap SimpleForm, :item_wrapper_tag => :li do
      with_input_for @user, :active, :radio, :item_wrapper_tag => :dl

      assert_select 'form dl input[type=radio]', :count => 2
      assert_no_select 'form li'
    end
  end

  test 'input radio allows disabling the item wrapper tag at input level' do
    swap SimpleForm, :item_wrapper_tag => :ul do
      with_input_for @user, :active, :radio, :item_wrapper_tag => false

      assert_select 'form input[type=radio]', :count => 2
      assert_no_select 'form li'
    end
  end

  test 'input radio wraps items in a span tag by default' do
    with_input_for @user, :active, :radio

    assert_select 'form span input[type=radio]', :count => 2
  end

  test 'input radio respects the nested boolean style config, generating nested label > input' do
    swap SimpleForm, :boolean_style => :nested do
      with_input_for @user, :active, :radio

      assert_select 'label[for=user_active_true] > input#user_active_true[type=radio]'
      assert_select 'label[for=user_active_true]', 'Yes'
      assert_select 'label[for=user_active_false] > input#user_active_false[type=radio]'
      assert_select 'label[for=user_active_false]', 'No'
      assert_no_select 'label.collection_radio'
    end
  end
end
