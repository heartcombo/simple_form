# encoding: UTF-8
# frozen_string_literal: true
require 'test_helper'

class CitextInputTest < ActionView::TestCase
  test 'input generates a email input type when email is citext' do
    with_input_for @user, :email, :citext
    assert_select "input.citext[type=email]"
  end

  test 'input generates a text area for citext' do
    with_input_for @user, :name, :citext
    assert_select "input.citext[type=text]"
  end
end
