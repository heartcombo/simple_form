require 'test_helper'

class ErrorTest < ActionView::TestCase

  test 'input should not generate a hint by default' do
    simple_form_for @user do |f|
      concat f.input :name
    end
    assert_no_select 'form span.hint'
  end

  test 'input should allow generating a hint' do
    simple_form_for @user do |f|
      concat f.input :name, :hint => 'Use with care...'
    end
    assert_select 'form span.hint', 'Use with care...'
  end

  test 'input should use i18n to find hints based on model and attribute' do
    store_translations(:en, :simple_form => { :hints => { :user => { :name =>
      'Content of this input will be capitalized...'
    } } }) do
      simple_form_for @user do |f|
        concat f.input :name
      end
      assert_select 'form span.hint', 'Content of this input will be capitalized...'
    end
  end

  test 'input should use i18n based only on attribute to pick up the label translation' do
    store_translations(:en, :simple_form => { :hints => { :name => 'Name hint!' } } ) do
      simple_form_for @user do |f|
        concat f.input :name
      end
      assert_select 'form span.hint', 'Name hint!'
    end
  end

  test 'input should allow disabling a hint that exists in i18n' do
    store_translations(:en, :simple_form => { :hints => { :name => 'Name hint!' } } ) do
      simple_form_for @user do |f|
        concat f.input :name, :hint => false
      end
      assert_no_select 'form span.hint'
    end
  end

  test 'hint should not be generated for hidden fields' do
    simple_form_for @user do |f|
      concat f.input :name, :hint => 'Bla bla bla', :as => :hidden
    end
    assert_no_select 'form span.hint'
  end
end
