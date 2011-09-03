require 'test_helper'

class WrapperTest < ActionView::TestCase
  def with_form_for(object, *args, &block)
    with_concat_form_for(object) do |f|
      f.input(*args, &block)
    end
  end

  test 'wrapper should not have error class for attribute without errors' do
    with_form_for @user, :active
    assert_no_select 'div.field_with_errors'
  end

  test 'wrapper should not have error class when object is not present' do
    with_form_for :project, :name
    assert_no_select 'div.field_with_errors'
  end

  test 'wrapper should add error class for attribute with errors' do
    with_form_for @user, :name
    assert_select 'div.field_with_errors'
  end

  test 'wrapper should support wrapping around an specific tag' do
    swap! SimpleForm, :wrapper_tag => :p do
      with_form_for @user, :name
      assert_select 'form p label[for=user_name]'
      assert_select 'form p input#user_name.string'
    end
  end

  test 'wrapper should add chosen error class for attribute with errors' do
    swap! SimpleForm, :wrapper_error_class => "omgError" do
      with_form_for @user, :name
      assert_select 'div.omgError'
    end
  end

  test 'wrapper should add chosen wrapper class' do
    swap! SimpleForm, :wrapper_class => "wrapper" do
      with_form_for @user, :active
      assert_select 'div.wrapper'
      assert_no_select 'div.input'

      with_form_for @user, :name
      assert_select 'div.wrapper'
      assert_no_select 'div.input'

      with_form_for :project, :name
      assert_select 'div.wrapper'
      assert_no_select 'div.input'
    end
  end

  test 'wrapper should not have disabled class by default' do
    with_form_for @user, :active
    assert_no_select 'div.disabled'
  end
  
  test 'wrapper should support no wrapping when wrapper is false' do
    with_form_for @user, :name, :wrapper => false	
    assert_select 'form > label[for=user_name]'	
    assert_select 'form > input#user_name.string'
  end

  test 'wrapper should wrapping tag adds required/optional css classes' do
    with_form_for @user, :name
    assert_select 'form div.input.required.string'

    with_form_for @user, :age, :required => false
    assert_select 'form div.input.optional.integer'
  end

  test 'wrapper should allow custom options to be given' do
    with_form_for @user, :name, :wrapper_html => { :id => "super_cool", :class => 'yay' }
    assert_select 'form #super_cool.required.string.yay'
  end

  test 'wrapper should allow tag to be given on demand' do
    with_form_for @user, :name, :wrapper_tag => :b
    assert_select 'form b.required.string'
  end

  test 'wrapper should allow wrapper class to be given on demand' do
    with_form_for @user, :name, :wrapper_class => :wrapper
    assert_select 'form div.wrapper.required.string'
  end
end
