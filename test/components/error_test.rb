require 'test_helper'

class ErrorTest < ActionView::TestCase

  def with_error_for(object, attribute, type, &block)
    simple_form_for object do |f|
      error = SimpleForm::Components::Error.new(f, attribute, type, {})
      concat(error.generate)
      yield error if block_given?
    end
  end

  test 'error should not generate content for hidden fields' do
    with_error_for @user, :name, :hidden do |error|
      assert error.generate.blank?
    end
  end

  test 'error should not generate content for attribute without errors' do
    with_error_for @user, :active, :boolean do |error|
      assert error.generate.blank?
    end
  end

  test 'error should not generate messages when object is not present' do
    with_error_for :project, :name, :string do |error|
      assert error.generate.blank?
    end
  end

  test 'error should generate messages for attribute with single error' do
    with_error_for @user, :name, :string
    assert_select 'span.error', "can't be blank"
  end

  test 'error should generate messages for attribute with several errors' do
    with_error_for @user, :age, :numeric
    assert_select 'span.error', 'is not a number and must be greater than 18'
  end
end
