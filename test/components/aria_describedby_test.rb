# frozen_string_literal: true
require 'test_helper'

class AriaDescribedbyTest < ActionView::TestCase
  def with_aria_form_for(object, attribute_name, options = {})
    swap_wrapper :default, custom_wrapper_with_aria_describedby do
      with_form_for object, attribute_name, options
    end
  end

  test 'aria_describedby links the input to its error' do
    with_aria_form_for @user, :name

    assert_select 'input#user_name[aria-describedby="user_name_error"]'
    assert_select 'span.error#user_name_error', 'cannot be blank'
  end

  test 'aria_describedby links the input to its hint' do
    with_aria_form_for @user, :username, hint: 'Pick a short one'

    assert_select 'input#user_username[aria-describedby="user_username_hint"]'
    assert_select 'span.hint#user_username_hint', 'Pick a short one'
  end

  test 'aria_describedby lists the error before the hint' do
    with_aria_form_for @user, :name, hint: 'Your full name'

    assert_select 'input#user_name[aria-describedby="user_name_error user_name_hint"]'
    assert_select 'span.hint#user_name_hint'
    assert_select 'span.error#user_name_error'
  end

  test 'aria_describedby does not add the attribute without an error or a hint' do
    with_aria_form_for @user, :username

    assert_no_select 'input[aria-describedby]'
    assert_no_select 'span.hint'
    assert_no_select 'span.error'
  end

  test 'aria_describedby skips the error when the error component is disabled' do
    with_aria_form_for @user, :name, error: false, hint: 'Your full name'

    assert_select 'input#user_name[aria-describedby="user_name_hint"]'
  end

  test 'aria_describedby appends to an aria-describedby given in input_html' do
    with_aria_form_for @user, :name, hint: 'Your full name', input_html: { 'aria-describedby': 'name_help' }
    assert_select 'input#user_name[aria-describedby="name_help user_name_error user_name_hint"]'

    with_aria_form_for @user, :name, input_html: { aria: { describedby: 'name_help' } }
    assert_select 'input#user_name[aria-describedby="name_help user_name_error"]'
  end

  test 'aria_describedby uses the ids given in hint_html and error_html' do
    with_aria_form_for @user, :name, hint: 'Your full name',
      hint_html: { id: 'name_hint', class: 'extra' }, error_html: { id: 'name_error' }

    assert_select 'input#user_name[aria-describedby="name_error name_hint"]'
    assert_select 'span.hint.extra#name_hint'
    assert_select 'span.error#name_error'
  end

  test 'aria_describedby links the input to a full error' do
    swap_wrapper :default, custom_wrapper_with_aria_describedby_and_full_error do
      with_form_for @user, :name
    end

    assert_select 'input#user_name[aria-describedby="user_name_error"]'
    assert_select 'span.error#user_name_error', 'Super User Name! cannot be blank'
  end

  test 'aria_describedby builds ids from nested object names' do
    @user.company = Company.new(1, 'Empresa')

    swap_wrapper :default, custom_wrapper_with_aria_describedby do
      with_concat_form_for @user do |f|
        f.simple_fields_for(:company) do |company_form|
          company_form.input :name, hint: 'Legal name'
        end
      end
    end

    assert_select 'input#user_company_attributes_name[aria-describedby="user_company_attributes_name_hint"]'
    assert_select 'span.hint#user_company_attributes_name_hint'
  end

  test 'aria_describedby works on forms without an object' do
    swap_wrapper :default, custom_wrapper_with_aria_describedby do
      with_form_for :project, :name, error: 'is taken'
    end

    assert_select 'input#project_name[aria-describedby="project_name_error"]'
    assert_select 'span.error#project_name_error', 'is taken'
  end

  test 'aria_describedby is set on every item of a collection' do
    @user.errors.add(:active, 'must select one')
    with_aria_form_for @user, :active, as: :radio_buttons

    assert_select 'input[type=radio][aria-describedby="user_active_error"]', count: 2
    assert_no_select 'input[type=hidden][aria-describedby]'
  end

  test 'inputs have no aria-describedby or hint and error ids without the component' do
    with_form_for @user, :name, hint: 'Your full name'

    assert_select 'span.hint'
    assert_select 'span.error'
    assert_no_select 'input[aria-describedby]'
    assert_no_select 'span.hint[id]'
    assert_no_select 'span.error[id]'
  end
end
