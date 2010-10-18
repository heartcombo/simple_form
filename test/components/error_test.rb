require 'test_helper'

class ErrorTest < ActionView::TestCase

  def with_error_for(object, attribute_name, type, options={}, &block)
    with_concat_form_for(object) do |f|
      f.attribute_name = attribute_name
      f.reflection     = Association.new(Company, :company, {}) if options.delete(:setup_association)
      f.input_type     = type
      f.options        = options

      SimpleForm::Inputs::Base.new(f).error.to_s
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

  test "error should not generate messages when object doesn't respond to errors method" do
    @user.instance_eval { undef errors }
    with_error_for @user, :name, :string
    assert_no_select 'span.error'
  end

  test 'error should generate messages for attribute with single error' do
    with_error_for @user, :name, :string
    assert_select 'span.error', "can't be blank"
  end

  test 'error should generate messages for attribute with one error when using first' do
    swap SimpleForm, :error_method => :first do
      with_error_for @user, :age, :numeric
      assert_select 'span.error', 'is not a number'
    end
  end

  test 'error should generate messages for attribute with several errors when using to_sentence' do
    swap SimpleForm, :error_method => :to_sentence do
      with_error_for @user, :age, :numeric
      assert_select 'span.error', 'is not a number and must be greater than 18'
    end
  end

  test 'error should be able to pass html options' do
    with_error_for @user, :name, :string, :error_html => { :id => 'error', :class => 'yay' }
    assert_select 'span#error.error.yay'
  end

  test 'error should find errors on attribute and association' do
    with_error_for @user, :company_id, :select, :setup_association => true, :error_method => :to_sentence
    assert_select 'span.error', 'must be valid and company must be present'
  end

  test 'error should include field name when option is set' do
    with_error_for @user, :age, :numeric, :add_attribute_name_to_error => true, :error_method => :to_sentence
    assert_select 'span.error', 'Age is not a number and must be greater than 18'
  end
end
