# encoding: UTF-8
require 'test_helper'

class GroupedCollectionInputTest < ActionView::TestCase
  test 'grouped collection accepts array collection form' do
    with_input_for @user, :name, :grouped_select,
      :collection => [['Authors', ['Jose', 'Carlos']], ['General', ['Bob', 'John']]],
      :group_method => :last

    assert_select 'select.grouped_select#user_name' do
      assert_select 'optgroup[label=Authors]' do
        assert_select 'option', 'Jose'
        assert_select 'option', 'Carlos'
      end

      assert_select 'optgroup[label=General]' do
        assert_select 'option', 'Bob'
        assert_select 'option', 'John'
      end
    end
  end

  test 'grouped collection accepts hash collection form' do
    with_input_for @user, :name, :grouped_select,
      :collection => { 'Authors' => ['Jose', 'Carlos'], 'General' => ['Bob', 'John'] },
      :group_method => :last

    assert_select 'select.grouped_select#user_name' do
      assert_select 'optgroup[label=Authors]' do
        assert_select 'option', 'Jose'
        assert_select 'option', 'Carlos'
      end

      assert_select 'optgroup[label=General]' do
        assert_select 'option', 'Bob'
        assert_select 'option', 'John'
      end
    end
  end

  test 'grouped collection accepts group_label_method option' do
    with_input_for @user, :name, :grouped_select,
      :collection => { ['Jose', 'Carlos'] => 'Authors' },
      :group_method => :first,
      :group_label_method => :last

    assert_select 'select.grouped_select#user_name' do
      assert_select 'optgroup[label=Authors]' do
        assert_select 'option', 'Jose'
        assert_select 'option', 'Carlos'
      end
    end
  end

  test 'grouped collection accepts label and value methods options' do
    with_input_for @user, :name, :grouped_select,
      :collection => { 'Authors' => ['Jose', 'Carlos'] },
      :group_method => :last,
      :label_method => :upcase,
      :value_method => :downcase

    assert_select 'select.grouped_select#user_name' do
      assert_select 'optgroup[label=Authors]' do
        assert_select 'option[value=jose]', 'JOSE'
        assert_select 'option[value=carlos]', 'CARLOS'
      end
    end
  end
end
