# frozen_string_literal: true
# encoding: UTF-8
require 'test_helper'

class RichTextAreaInputTest < ActionView::TestCase
  test 'input generates a text area for text attributes' do
    with_input_for @user, :description, :text
    assert_select 'textarea.text#user_description'
  end

  test 'input generates a text area for text attributes that accept placeholder' do
    with_input_for @user, :description, :text, placeholder: 'Put in some text'
    assert_select 'textarea.text[placeholder="Put in some text"]'
  end
end
