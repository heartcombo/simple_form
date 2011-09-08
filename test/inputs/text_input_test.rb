# encoding: UTF-8
require 'test_helper'

class TextInputTest < ActionView::TestCase
  test 'input should generate a text area for text attributes' do
    with_input_for @user, :description, :text
    assert_select 'textarea.text#user_description'
  end

  test 'input should generate a text area for text attributes that accept placeholder' do
    with_input_for @user, :description, :text, :placeholder => 'Put in some text'
    assert_select 'textarea.text[placeholder=Put in some text]'
  end

  test 'input should get maxlength from column definition for text attributes' do
    with_input_for @user, :description, :text
    assert_select 'textarea.text[maxlength=200]'
  end

  test 'input should infer maxlength column definition from validation when present for text attributes' do
    with_input_for @validating_user, :description, :text
    assert_select 'textarea.text[maxlength=50]'
  end

  test 'when not using HTML5, does not show maxlength attribute for text attributes' do
    swap SimpleForm, :html5 => false do
      with_input_for @user, :description, :text
      assert_no_select 'textarea.text[maxlength]'
    end
  end

  test 'when not using HTML5, does not show maxlength attribute with validating lenght text attribute' do
    swap SimpleForm, :html5 => false do
      with_input_for @validating_user, :name, :string
      assert_no_select 'input.string[maxlength]'
    end
  end
end
