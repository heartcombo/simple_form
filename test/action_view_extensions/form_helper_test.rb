require 'test_helper'

class FormHelperTest < ActionView::TestCase

  test 'SimpleForm for yields an instance of FormBuilder' do
    simple_form_for :user do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
    end
  end

  test 'SimpleForm should add default class to form' do
    with_concat_form_for(:user)
    assert_select 'form.simple_form'
  end

  test 'SimpleForm should use default browser validations by default' do
    with_concat_form_for(:user)
    assert_no_select 'form[novalidate]'
  end

  test 'SimpleForm should not use default browser validations if specified in the configuration options' do
    swap SimpleForm, :browser_validations => false do
      with_concat_form_for(:user)
      assert_select 'form[novalidate="novalidate"]'
    end
  end

  test 'a form specific disabled validation option should override the default enabled browser validation configuration option' do
    with_concat_form_for(:user, :html => { :novalidate => true })
    assert_select 'form[novalidate="novalidate"]'
  end

  test 'a form specific enabled validation option should override the disabled browser validation configuration option' do
    swap SimpleForm, :browser_validations => false do
      with_concat_form_for(:user, :html => { :novalidate => false })
      assert_no_select 'form[novalidate]'
    end
  end

  test 'SimpleForm should add object name as css class to form when object is not present' do
    with_concat_form_for(:user, :html => { :novalidate => true })
    assert_select 'form.simple_form.user'
  end

  test 'SimpleForm should add :as option as css class to form when object is not present' do
    with_concat_form_for(:user, :as => 'superuser')
    assert_select 'form.simple_form.superuser'
  end

  test 'SimpleForm should add object class name with new prefix as css class to form if record is not persisted' do
    @user.new_record!
    with_concat_form_for(@user)
    assert_select 'form.simple_form.new_user'
  end

  test 'SimpleForm should add :as option with new prefix as css class to form if record is not persisted' do
    @user.new_record!
    with_concat_form_for(@user, :as => 'superuser')
    assert_select 'form.simple_form.new_superuser'
  end

  test 'SimpleForm should add edit class prefix as css class to form if record is persisted' do
    with_concat_form_for(@user)
    assert_select 'form.simple_form.edit_user'
  end

  test 'SimpleForm should add :as options with edit prefix as css class to form if record is persisted' do
    with_concat_form_for(@user, :as => 'superuser')
    assert_select 'form.simple_form.edit_superuser'
  end

  test 'SimpleForm should add last object name as css class to form when there is array of objects' do
    with_concat_form_for([Company.new, @user])
    assert_select 'form.simple_form.edit_user'
  end

  test 'SimpleForm should not add object class to form if css_class is specified' do
    with_concat_form_for(:user, :html => {:class => nil})
    assert_no_select 'form.user'
  end

  test 'SimpleForm should add custom class to form if css_class is specified' do
    with_concat_form_for(:user, :html => {:class => 'my_class'})
    assert_select 'form.my_class'
  end

  test 'pass options to SimpleForm' do
    with_concat_form_for(:user, :url => '/account', :html => { :id => 'my_form' })
    assert_select 'form#my_form'
    assert_select 'form[action=/account]'
  end

  test 'fields for yields an instance of FormBuilder' do
    with_concat_form_for(:user) do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
    end
  end

  test 'fields for with a hash like model yeilds an instance of FormBuilder' do
    with_concat_fields_for(:author, HashBackedAuthor.new) do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
      f.input :name
    end

    assert_select "input[name='author[name]'][value='hash backed author']"
  end

  test 'custom error proc is not destructive' do
    swap_field_error_proc do
      result = nil
      simple_form_for :user do |f|
        result = simple_fields_for 'address' do
          'hello'
        end
      end

      assert_equal 'hello', result
    end
  end

  test 'custom error proc survives an exception' do
    swap_field_error_proc do
      begin
        simple_form_for :user do |f|
          simple_fields_for 'address' do
            raise 'an exception'
          end
        end
      rescue StandardError
      end
    end
  end

  private

  def swap_field_error_proc(expected_error_proc = lambda {})
    swap ActionView::Base, :field_error_proc => expected_error_proc do
      yield

      assert_equal expected_error_proc, ActionView::Base.field_error_proc
    end
  end
end
