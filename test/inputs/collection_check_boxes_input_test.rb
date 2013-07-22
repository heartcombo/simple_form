# encoding: UTF-8
require 'test_helper'

class CollectionCheckBoxesInputTest < ActionView::TestCase
  setup do
    SimpleForm::Inputs::CollectionCheckBoxesInput.reset_i18n_cache :boolean_collection
  end

  test 'input check boxes should not include for attribute by default' do
    with_input_for @user, :gender, :check_boxes, collection: [:male, :female]
    assert_select 'label'
    assert_no_select 'label[for=user_gender]'
  end

  test 'input check boxes should include for attribute when giving as html option' do
    with_input_for @user, :gender, :check_boxes, collection: [:male, :female], label_html: { for: 'gender' }
    assert_select 'label[for=gender]'
  end

  test 'collection input with check_boxes type should not generate required html attribute' do
    with_input_for @user, :name, :check_boxes, collection: ['Jose', 'Carlos']
    assert_select 'input.required'
    assert_no_select 'input[required]'
  end

  test 'collection input with check_boxes type should not generate aria-required html attribute' do
    with_input_for @user, :name, :check_boxes, collection: ['Jose', 'Carlos']
    assert_select 'input.required'
    assert_no_select 'input[aria-required]'
  end

  test 'input should do automatic collection translation for check_box types using defaults key' do
    store_translations(:en, simple_form: { options: { defaults: {
      gender: { male: 'Male', female: 'Female'}
    } } } ) do
      with_input_for @user, :gender, :check_boxes, collection: [:male, :female]
      assert_select 'input[type=checkbox][value=male]'
      assert_select 'input[type=checkbox][value=female]'
      assert_select 'label.collection_check_boxes', 'Male'
      assert_select 'label.collection_check_boxes', 'Female'
    end
  end

  test 'input should do automatic collection translation for check_box types using specific object key' do
    store_translations(:en, simple_form: { options: { user: {
      gender: { male: 'Male', female: 'Female'}
    } } } ) do
      with_input_for @user, :gender, :check_boxes, collection: [:male, :female]
      assert_select 'input[type=checkbox][value=male]'
      assert_select 'input[type=checkbox][value=female]'
      assert_select 'label.collection_check_boxes', 'Male'
      assert_select 'label.collection_check_boxes', 'Female'
    end
  end

  test 'input check boxes does not wrap the collection by default' do
    with_input_for @user, :active, :check_boxes

    assert_select 'form input[type=checkbox]', count: 2
    assert_no_select 'form ul'
  end

  test 'input check boxes accepts html options as the last element of collection' do
    with_input_for @user, :name, :check_boxes, collection: [['Jose', 'jose', class: 'foo']]
    assert_select 'input.foo[type=checkbox][value=jose]'
  end

  test 'input check boxes wraps the collection in the configured collection wrapper tag' do
    swap SimpleForm, collection_wrapper_tag: :ul do
      with_input_for @user, :active, :check_boxes

      assert_select 'form ul input[type=checkbox]', count: 2
    end
  end

  test 'input check boxes does not wrap the collection when configured with falsy values' do
    swap SimpleForm, collection_wrapper_tag: false do
      with_input_for @user, :active, :check_boxes

      assert_select 'form input[type=checkbox]', count: 2
      assert_no_select 'form ul'
    end
  end

  test 'input check boxes allows overriding the collection wrapper tag at input level' do
    swap SimpleForm, collection_wrapper_tag: :ul do
      with_input_for @user, :active, :check_boxes, collection_wrapper_tag: :section

      assert_select 'form section input[type=checkbox]', count: 2
      assert_no_select 'form ul'
    end
  end

  test 'input check boxes allows disabling the collection wrapper tag at input level' do
    swap SimpleForm, collection_wrapper_tag: :ul do
      with_input_for @user, :active, :check_boxes, collection_wrapper_tag: false

      assert_select 'form input[type=checkbox]', count: 2
      assert_no_select 'form ul'
    end
  end

  test 'input check boxes renders the wrapper tag with the configured wrapper class' do
    swap SimpleForm, collection_wrapper_tag: :ul, collection_wrapper_class: 'inputs-list' do
      with_input_for @user, :active, :check_boxes

      assert_select 'form ul.inputs-list input[type=checkbox]', count: 2
    end
  end

  test 'input check boxes allows giving wrapper class at input level only' do
    swap SimpleForm, collection_wrapper_tag: :ul do
      with_input_for @user, :active, :check_boxes, collection_wrapper_class: 'items-list'

      assert_select 'form ul.items-list input[type=checkbox]', count: 2
    end
  end

  test 'input check boxes uses both configured and given wrapper classes for wrapper tag' do
    swap SimpleForm, collection_wrapper_tag: :ul, collection_wrapper_class: 'inputs-list' do
      with_input_for @user, :active, :check_boxes, collection_wrapper_class: 'items-list'

      assert_select 'form ul.inputs-list.items-list input[type=checkbox]', count: 2
    end
  end

  test 'input check boxes wraps each item in the configured item wrapper tag' do
    swap SimpleForm, item_wrapper_tag: :li do
      with_input_for @user, :active, :check_boxes

      assert_select 'form li input[type=checkbox]', count: 2
    end
  end

  test 'input check boxes does not wrap items when configured with falsy values' do
    swap SimpleForm, item_wrapper_tag: false do
      with_input_for @user, :active, :check_boxes

      assert_select 'form input[type=checkbox]', count: 2
      assert_no_select 'form li'
    end
  end

  test 'input check boxes allows overriding the item wrapper tag at input level' do
    swap SimpleForm, item_wrapper_tag: :li do
      with_input_for @user, :active, :check_boxes, item_wrapper_tag: :dl

      assert_select 'form dl input[type=checkbox]', count: 2
      assert_no_select 'form li'
    end
  end

  test 'input check boxes allows disabling the item wrapper tag at input level' do
    swap SimpleForm, item_wrapper_tag: :ul do
      with_input_for @user, :active, :check_boxes, item_wrapper_tag: false

      assert_select 'form input[type=checkbox]', count: 2
      assert_no_select 'form li'
    end
  end

  test 'input check boxes wraps items in a span tag by default' do
    with_input_for @user, :active, :check_boxes

    assert_select 'form span input[type=checkbox]', count: 2
  end

  test 'input check boxes renders the item wrapper tag with a default class "checkbox"' do
    with_input_for @user, :active, :check_boxes, item_wrapper_tag: :li

    assert_select 'form li.checkbox input[type=checkbox]', count: 2
  end

  test 'input check boxes renders the item wrapper tag with the configured item wrapper class' do
    swap SimpleForm, item_wrapper_tag: :li, item_wrapper_class: 'item' do
      with_input_for @user, :active, :check_boxes

      assert_select 'form li.checkbox.item input[type=checkbox]', count: 2
    end
  end

  test 'input check boxes allows giving item wrapper class at input level only' do
    swap SimpleForm, item_wrapper_tag: :li do
      with_input_for @user, :active, :check_boxes, item_wrapper_class: 'item'

      assert_select 'form li.checkbox.item input[type=checkbox]', count: 2
    end
  end

  test 'input check boxes uses both configured and given item wrapper classes for item wrapper tag' do
    swap SimpleForm, item_wrapper_tag: :li, item_wrapper_class: 'item' do
      with_input_for @user, :active, :check_boxes, item_wrapper_class: 'inline'

      assert_select 'form li.checkbox.item.inline input[type=checkbox]', count: 2
    end
  end

  test 'input check boxes respects the nested boolean style config, generating nested label > input' do
    swap SimpleForm, boolean_style: :nested do
      with_input_for @user, :active, :check_boxes

      assert_select 'label.checkbox > input#user_active_true[type=checkbox]'
      assert_select 'label.checkbox', 'Yes'
      assert_select 'label.checkbox > input#user_active_false[type=checkbox]'
      assert_select 'label.checkbox', 'No'
      assert_no_select 'label.collection_radio_buttons'
    end
  end

  test 'input check boxes with nested style overrides configured item wrapper tag, forcing the :label' do
    swap SimpleForm, boolean_style: :nested, item_wrapper_tag: :li do
      with_input_for @user, :active, :check_boxes

      assert_select 'label.checkbox > input'
      assert_no_select 'li'
    end
  end

  test 'input check boxes with nested style overrides given item wrapper tag, forcing the :label' do
    swap SimpleForm, boolean_style: :nested do
      with_input_for @user, :active, :check_boxes, item_wrapper_tag: :li

      assert_select 'label.checkbox > input'
      assert_no_select 'li'
    end
  end

  test 'input check boxes with nested style accepts giving extra wrapper classes' do
    swap SimpleForm, boolean_style: :nested do
      with_input_for @user, :active, :check_boxes, item_wrapper_class: "inline"

      assert_select 'label.checkbox.inline > input'
    end
  end
end
