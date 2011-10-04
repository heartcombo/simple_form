# encoding: UTF-8
require 'test_helper'

class FileInputTest < ActionView::TestCase
  test 'input should generate a file field' do
    with_input_for @user, :name, :file
    assert_select 'input#user_name[type=file]'
  end

  test "input should generate a file field that doesn't accept placeholder" do
    with_input_for @user, :name, :file, :placeholder => 'Put in some text'
    assert_no_select 'input[placeholder]'
  end
end
