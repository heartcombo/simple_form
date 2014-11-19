require 'test_helper'

# Tests for f.input_field
class InputFieldTest < ActionView::TestCase
  test "builder input_field only renders the input tag, nothing else" do
    with_concat_form_for(@user) do |f|
      f.input_field :name
    end
    assert_select 'form > input.required.string'
    assert_no_select 'div.string'
    assert_no_select 'label'
    assert_no_select '.hint'
  end

  test 'builder input_field allows overriding default input type' do
    with_concat_form_for(@user) do |f|
      f.input_field :name, as: :text
    end

    assert_no_select 'input#user_name'
    assert_select 'textarea#user_name.text'
  end

  test 'builder input_field generates input type based on column type' do
    with_concat_form_for(@user) do |f|
      f.input_field :age
    end

    assert_select 'input[type=number].integer#user_age'
  end

  test 'builder input_field is able to disable any component' do
    with_concat_form_for(@user) do |f|
      f.input_field :age, html5: false
    end

    assert_no_select 'input[html5=false]#user_age'
    assert_select 'input[type=text].integer#user_age'
  end

  test 'builder input_field allows passing options to input tag' do
    with_concat_form_for(@user) do |f|
      f.input_field :name, id: 'name_input', class: 'name'
    end

    assert_select 'input.string.name#name_input'
  end

  test 'builder input_field does not modify the options hash' do
    options = { id: 'name_input', class: 'name' }

    with_concat_form_for(@user) do |f|
      f.input_field :name, options
    end

    assert_select 'input.string.name#name_input'
    assert_equal({ id: 'name_input', class: 'name' }, options)
  end


  test 'builder input_field generates an input tag with a clean HTML' do
    with_concat_form_for(@user) do |f|
      f.input_field :name, as: :integer, class: 'name'
    end

    assert_no_select 'input.integer[input_html]'
    assert_no_select 'input.integer[as]'
  end

  test 'builder input_field uses i18n to translate placeholder text' do
    store_translations(:en, simple_form: { placeholders: { user: {
      name: 'Name goes here'
    } } }) do

      with_concat_form_for(@user) do |f|
        f.input_field :name
      end

      assert_select 'input.string[placeholder="Name goes here"]'
    end
  end

  test 'builder input_field uses min_max component' do
    with_concat_form_for(@other_validating_user) do |f|
      f.input_field :age, as: :integer
    end

    assert_select 'input[min="18"]'
  end

  test 'builder input_field does not use pattern component by default' do
    with_concat_form_for(@other_validating_user) do |f|
      f.input_field :country, as: :string
    end

    assert_no_select 'input[pattern="\w+"]'
  end

  test 'builder input_field infers pattern from attributes' do
    with_concat_form_for(@other_validating_user) do |f|
      f.input_field :country, as: :string, pattern: true
    end

    assert_select 'input[pattern="\w+"]'
  end

  test 'builder input_field accepts custom patter' do
    with_concat_form_for(@other_validating_user) do |f|
      f.input_field :country, as: :string, pattern: '\d+'
    end

    assert_select 'input[pattern="\d+"]'
  end

  test 'builder input_field uses readonly component' do
    with_concat_form_for(@other_validating_user) do |f|
      f.input_field :age, as: :integer, readonly: true
    end

    assert_select 'input.integer.readonly[readonly]'
  end

  test 'builder input_field uses maxlength component' do
    with_concat_form_for(@validating_user) do |f|
      f.input_field :name, as: :string
    end

    assert_select 'input.string[maxlength="25"]'
  end

  test 'builder collection input_field generates input tag with a clean HTML' do
    with_concat_form_for(@user) do |f|
      f.input_field :status, collection: ['Open', 'Closed'], class: 'status', label_method: :to_s, value_method: :to_s
    end

    assert_no_select 'select.status[input_html]'
    assert_no_select 'select.status[collection]'
    assert_no_select 'select.status[label_method]'
    assert_no_select 'select.status[value_method]'
  end

  test 'build input_field does not treat "boolean_style" as a HTML attribute' do
    with_concat_form_for(@user) do |f|
      f.input_field :active, boolean_style: :nested
    end

    assert_no_select 'input.boolean[boolean_style]'
  end

  test 'build input_field without pattern component use the pattern string' do
    swap_wrapper :default, self.custom_wrapper_with_html5_components do
      with_concat_form_for(@user) do |f|
        f.input_field :name, pattern: '\w+'
      end

      assert_select 'input[pattern="\w+"]'
    end
  end

  test 'build input_field without placeholder component use the placeholder string' do
    swap_wrapper :default, self.custom_wrapper_with_html5_components do
      with_concat_form_for(@user) do |f|
        f.input_field :name, placeholder: 'Placeholder'
      end

      assert_select 'input[placeholder="Placeholder"]'
    end
  end

  test 'build input_field without maxlength component use the maxlength string' do
    swap_wrapper :default, self.custom_wrapper_with_html5_components do
      with_concat_form_for(@user) do |f|
        f.input_field :name, maxlength: 5
      end

      assert_select 'input[maxlength="5"]'
    end
  end

  test 'build input_field without readonly component use the readonly string' do
    swap_wrapper :default, self.custom_wrapper_with_html5_components do
      with_concat_form_for(@user) do |f|
        f.input_field :name, readonly: true
      end

      assert_select 'input[readonly="readonly"]'
    end
  end
end
