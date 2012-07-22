require 'test_helper'

# Tests for f.input_field
class InputFieldTest < ActionView::TestCase
  test "builder input_field should only render the input tag, nothing else" do
    with_concat_form_for(@user) do |f|
      f.input_field :name
    end
    assert_select 'form > input.required.string'
    assert_no_select 'div.string'
    assert_no_select 'label'
    assert_no_select '.hint'
  end

  test 'builder input_field should allow overriding default input type' do
    with_concat_form_for(@user) do |f|
      f.input_field :name, :as => :text
    end

    assert_no_select 'input#user_name'
    assert_select 'textarea#user_name.text'
  end

  test 'builder input_field should allow passing options to input tag' do
    with_concat_form_for(@user) do |f|
      f.input_field :name, :id => 'name_input', :class => 'name'
    end

    assert_select 'input.string.name#name_input'
  end

  test 'builder input_field should not modify the options hash' do
    options = { :id => 'name_input', :class => 'name' }

    with_concat_form_for(@user) do |f|
      f.input_field :name, options
    end

    assert_select 'input.string.name#name_input'
    assert_equal({ :id => 'name_input', :class => 'name' }, options)
  end


  test 'builder input_field should generate an input tag with a clean HTML' do
    with_concat_form_for(@user) do |f|
      f.input_field :name, :as => :integer, :class => 'name'
    end

    assert_no_select 'input.integer[input_html]'
    assert_no_select 'input.integer[as]'
  end

  test 'builder input_field should use i18n to translate placeholder text' do
    store_translations(:en, :simple_form => { :placeholders => { :user => {
      :name => 'Name goes here'
    } } }) do

      with_concat_form_for(@user) do |f|
        f.input_field :name
      end

      assert_select 'input.string[placeholder=Name goes here]'
    end
  end

  test 'builder input_field should use min_max component' do
    with_concat_form_for(@other_validating_user) do |f|
      f.input_field :age, :as => :integer
    end

    assert_select 'input[min=18]'
  end

  test 'builder input_field should use pattern component' do
    with_concat_form_for(@other_validating_user) do |f|
      f.input_field :country, :as => :string
    end

    assert_select 'input[pattern="\w+"]'
  end

  test 'builder input_field should use readonly component' do
    with_concat_form_for(@other_validating_user) do |f|
      f.input_field :age, :as => :integer, :readonly => true
    end

    assert_select 'input.integer.readonly[readonly]'
  end

  test 'builder input_field should use maxlength component' do
    with_concat_form_for(@validating_user) do |f|
      f.input_field :name, :as => :string
    end

    assert_select 'input.string[maxlength=25]'
  end

  test 'builder collection input_field should generate input tag with a clean HTML' do
    with_concat_form_for(@user) do |f|
      f.input_field :status, :collection => ['Open', 'Closed'], :class => 'status', :label_method => :to_s, :value_method => :to_s
    end

    assert_no_select 'select.status[input_html]'
    assert_no_select 'select.status[collection]'
    assert_no_select 'select.status[label_method]'
    assert_no_select 'select.status[value_method]'
  end
end
