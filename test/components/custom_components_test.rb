# frozen_string_literal: true

require 'test_helper'

# Module that represents a custom component.
module Numbers
  def number(wrapper_options = nil)
    @number ||= options[:number].to_s.html_safe
  end
end

# Module that represents a custom component.
module InputGroup
  def prepend(wrapper_options = nil)
    span_tag = content_tag(:span, options[:prepend], class: 'input-group-text')
    template.content_tag(:div, span_tag, class: 'input-group-prepend')
  end

  def append(wrapper_options = nil)
    span_tag = content_tag(:span, options[:append], class: 'input-group-text')
    template.content_tag(:div, span_tag, class: 'input-group-append')
  end
end

class CustomComponentsTest < ActionView::TestCase
  test 'includes the custom components' do
    SimpleForm.include_component Numbers

    custom_wrapper = SimpleForm.build tag: :div, class: "custom_wrapper" do |b|
      b.use :number, wrap_with: { tag: 'div', class: 'number' }
    end

    with_form_for @user, :name, number: 1, wrapper: custom_wrapper

    assert_select 'div.number', text: '1'
  end

  test 'includes custom components and use it as optional in the wrapper' do
    SimpleForm.include_component InputGroup

    custom_wrapper = SimpleForm.build tag: :div, class: 'custom_wrapper' do |b|
      b.use :label
      b.optional :prepend
      b.use :input
      b.use :append
    end

    with_form_for @user, :name, prepend: true, wrapper: custom_wrapper

    assert_select 'div.input-group-prepend > span.input-group-text'
    assert_select 'div.input-group-append > span.input-group-text'
  end

  test 'raises a TypeError when the component is not a Module' do
    component = 'MyComponent'

    exception = assert_raises TypeError do 
      SimpleForm.include_component(component)
    end
    assert_equal exception.message, "SimpleForm.include_component expects a module but got: String"
  end
end
