require 'test_helper'

class ErrorTest < ActionView::TestCase

  def with_error_for(object, attribute_name, type, options={}, &block)
    simple_form_for object do |f|
      f.attribute_name = attribute_name
      f.reflection     = Association.new(Company, :company, {}) if options.delete(:setup_association)
      f.input_type     = type
      f.options        = options

      concat(SimpleForm::Inputs::Base.new(f).error.to_s)
    end
  end

  test 'error should not generate content for attribute without errors' do
    with_error_for @user, :active, :boolean
    assert_no_select 'span.error'
  end

  test 'error should not generate messages when object is not present' do
    with_error_for :project, :name, :string
    assert_no_select 'span.error'
  end

  test 'error should generate messages for attribute with single error' do
    with_error_for @user, :name, :string
    assert_select 'span.error', "can't be blank"
  end

  test 'error should generate messages for attribute with several errors' do
    with_error_for @user, :age, :numeric
    assert_select 'span.error', 'is not a number and must be greater than 18'
  end

  test 'error should be able to pass html options' do
    with_error_for @user, :name, :string, :error_html => { :id => 'error', :class => 'yay' }
    assert_select 'span#error.error.yay'
  end

  test 'error should find errors on attribute and association' do
    with_error_for @user, :company_id, :select, :setup_association => true
    assert_select 'span.error', 'must be valid and company must be present'
  end
end
