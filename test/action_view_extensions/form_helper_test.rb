require 'test_helper'

class FormHelperTest < ActionView::TestCase

  test 'simple form for yields an instance of FormBuilder' do
    simple_form_for :user do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
    end
  end

  test 'simple form should add default class to form' do
    simple_form_for :user do |f| end
    assert_select 'form.simple_form'
  end

  test 'simple form should add object name as css class to form when object is not present' do
    simple_form_for :user do |f| end
    assert_select 'form.simple_form.user'
  end

  test 'simple form should add object class name as css class to form' do
    simple_form_for @user do |f| end
    assert_select 'form.simple_form.user'
  end

  test 'pass options to simple form' do
    simple_form_for :user, :url => '/account', :html => { :id => 'my_form' } do |f| end
    assert_select 'form#my_form'
    assert_select 'form[action=/account]'
  end

  test 'fields for yields an instance of FormBuilder' do
    simple_fields_for :user do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
    end
  end

  test 'remote form for yields an instance of FormBuilder' do
    simple_remote_form_for :user do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
    end
    assert_select "form[onsubmit]"
  end

  test 'pass options to simple remote form' do
    simple_remote_form_for :user, :url => '/account', :html => { :id => 'my_form' } do |f| end
    assert_select 'form#my_form'
    assert_select 'form[action=/account]'
  end
end
