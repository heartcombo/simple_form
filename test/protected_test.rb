# encoding: UTF-8
require 'test_helper'

class ProtectedTest < ActionView::TestCase
  
  def with_form_for(object, *args, &block)
    with_concat_form_for(object) do |f|
      f.input(*args, &block)
    end
  end
  
  test 'builder should generate text fields for attr_protected string columns if option is false' do
    swap SimpleForm, :use_attr_protected => false do
      with_form_for @user, :name
      assert_select 'form input#user_name.string'
      assert_no_select 'form input#user_name.protected'
    end
  end
  
  test 'builder should generate text fields for attr_protected string columns with protected class if option is true' do
    swap SimpleForm, :use_attr_protected => true do
      with_form_for @user, :name
      assert_select 'form input#user_name.protected'
    end
  end
  
  test 'builder should generate text fields for non-protected string columns without protected class even if option is true' do
    swap SimpleForm, :use_attr_protected => true do
      with_form_for @user, :status
      assert_select 'form input#user_status.string'
      assert_no_select 'form input#user_status.protected'
    end
  end
  
  test 'builder should generate text fields for attr_protected string columns with configurable class if option is true' do
    swap SimpleForm, :use_attr_protected => true, :attr_protected_class => 'locked' do
      with_form_for @user, :name
      assert_select 'form input#user_name.locked'
      assert_no_select 'form input#user_name.protected'
    end
  end
  
  test 'builder should generate disabled text fields for attr_protected string columns if both options are true' do
    swap SimpleForm, :use_attr_protected => true, :disable_when_attr_protected => true do
      with_form_for @user, :name
      assert_select 'form input#user_name.string'
      assert_select 'form input#user_name.string[disabled]'
      assert_select 'form input#user_name.protected'
      assert_select 'form input#user_name.protected[disabled]'
    end
  end
  
  test 'builder should generate enabled text fields for non-protected string columns even if both options are true' do
    swap SimpleForm, :use_attr_protected => true, :disable_when_attr_protected => true do
      with_form_for @user, :status
      assert_select 'form input#user_status.string'
      assert_no_select 'form input#user_status.string[disabled]'
      assert_no_select 'form input#user_status.protected'
      assert_no_select 'form input#user_status.protected[disabled]'
    end
  end
  
  test 'builder should generate enabled text fields for attr_protected string columns if one option is false' do
    swap SimpleForm, :use_attr_protected => true, :disable_when_attr_protected => false do
      with_form_for @user, :name
      assert_select 'form input#user_name.string'
      assert_no_select 'form input#user_name.string[disabled]'
      assert_select 'form input#user_name.protected'
      assert_no_select 'form input#user_name.protected[disabled]'
    end
  end
  
  test 'builder should generate disabled text fields for attr_protected string columns if other option is false' do
    swap SimpleForm, :use_attr_protected => false, :disable_when_attr_protected => true do
      with_form_for @user, :name
      assert_select 'form input#user_name.string'
      assert_no_select 'form input#user_name.string[disabled]'
      assert_no_select 'form input#user_name.protected'
      assert_no_select 'form input#user_name.protected[disabled]'
    end
  end
end