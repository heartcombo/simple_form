# encoding: UTF-8
require 'test_helper'

class LabelTest < ActionView::TestCase
  def with_label_for(object, *args, &block)
    with_concat_form_for(object) do |f|
      f.label(*args, &block)
    end
  end

  test 'builder should generate a label for the attribute' do
    with_label_for @user, :name
    assert_select 'label.string[for=user_name]', /Name/
  end

  test 'builder should generate a label for the boolean attrbiute' do
    with_label_for @user, :name, as: :boolean
    assert_select 'label.boolean[for=user_name]', /Name/
    assert_no_select 'label[as=boolean]'
  end

  test 'builder should generate a label component tag with a clean HTML' do
    with_label_for @user, :name
    assert_no_select 'label.string[label_html]'
  end

  test 'builder should add a required class to label if the attribute is required' do
    with_label_for @validating_user, :name
    assert_select 'label.string.required[for=validating_user_name]', /Name/
  end

  test 'builder should escape label text' do
    with_label_for @user, :name, label: '<script>alert(1337)</script>', required: false
    assert_select 'label.string', "&lt;script&gt;alert(1337)&lt;/script&gt;"
  end

  test 'builder should not escape label text if it is safe' do
    with_label_for @user, :name, label: '<script>alert(1337)</script>'.html_safe, required: false
    assert_select 'label.string script', "alert(1337)"
  end

  test 'builder should allow passing options to label tag' do
    with_label_for @user, :name, label: 'My label', id: 'name_label'
    assert_select 'label.string#name_label', /My label/
  end

  test 'builder label should generate label tag with clean HTML' do
    with_label_for @user, :name, label: 'My label', required: true, id: 'name_label'
    assert_select 'label.string#name_label', /My label/
    assert_no_select 'label[label]'
    assert_no_select 'label[required]'
  end

  test 'builder should not modify the options hash' do
    options = { label: 'My label', id: 'name_label' }
    with_label_for @user, :name, options
    assert_select 'label.string#name_label', /My label/
    assert_equal({ label: 'My label', id: 'name_label' }, options)
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
    swap SimpleForm, label_text: lambda { |l, r| "#{l}:" } do
      with_label_for @user, :age
      assert_select 'label.integer[for=user_age]', "Age:"
    end
  end
end
