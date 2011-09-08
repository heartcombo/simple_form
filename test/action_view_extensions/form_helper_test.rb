require 'test_helper'

class FormHelperTest < ActionView::TestCase

  test 'simple form for yields an instance of FormBuilder' do
    simple_form_for :user do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
    end
  end

  test 'simple form should add default class to form' do
    concat(simple_form_for(:user) do |f| end)
    assert_select 'form.simple_form'
  end

  test 'simple form should use default browser validations by default' do
    concat(simple_form_for(:user) do |f| end)
    assert_no_select 'form[novalidate]'
  end

  test 'simple form should not use default browser validations if specified in the configuration options' do
    swap SimpleForm, :browser_validations => false do
      concat(simple_form_for(:user) do |f| end)
      assert_select 'form[novalidate="novalidate"]'
    end
  end

  test 'a form specific disabled validation option should override the default enabled browser validation configuration option' do
    concat(simple_form_for(:user, :html => { :novalidate => true }) do |f| end)
    assert_select 'form[novalidate="novalidate"]'
  end

  test 'a form specific enabled validation option should override the disabled browser validation configuration option' do
    swap SimpleForm, :browser_validations => false do
      concat(simple_form_for(:user, :html => { :novalidate => false }) do |f| end)
      assert_no_select 'form[novalidate]'
    end
  end

  test 'simple form should add object name as css class to form when object is not present' do
    concat(simple_form_for(:user) do |f| end)
    assert_select 'form.simple_form.user'
  end

  test 'simple form should add object class name as css class to form' do
    concat(simple_form_for(@user) do |f| end)
    assert_select 'form.simple_form.user'
  end

  test 'simple form should not add object class to form if css_class is specified' do
    concat(simple_form_for(:user, :html => {:class => nil}) do |f| end)
    assert_no_select 'form.user'
  end

  test 'simple form should add custom class to form if css_class is specified' do
    concat(simple_form_for(:user, :html => {:class => 'my_class'}) do |f| end)
    assert_select 'form.my_class'
  end

  test 'pass options to simple form' do
    concat(simple_form_for(:user, :url => '/account', :html => { :id => 'my_form' }) do |f| end)
    assert_select 'form#my_form'
    assert_select 'form[action=/account]'
  end

  test 'fields for yields an instance of FormBuilder' do
    concat(simple_fields_for(:user) do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
    end)
  end

  test 'fields for with a hash like model yeilds an instance of FormBuilder' do
    @hash_backed_author = HashBackedAuthor.new

    concat(simple_fields_for(:author, @hash_backed_author) do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
      f.input :name
    end)

    assert_select "input[name='author[name]'][value='hash backed author']"
  end
end
