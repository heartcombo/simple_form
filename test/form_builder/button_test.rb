# encoding: UTF-8
require 'test_helper'

class ButtonTest < ActionView::TestCase
  def with_button_for(object, *args)
    with_concat_form_for(object) do |f|
      f.button(*args)
    end
  end

  test 'builder should create buttons' do
    with_button_for :post, :submit
    assert_select 'form input.button[type=submit][value=Save Post]'
  end

  test 'builder should create buttons for records' do
    @user.new_record!
    with_button_for @user, :submit
    assert_select 'form input.button[type=submit][value=Create User]'
  end
end
