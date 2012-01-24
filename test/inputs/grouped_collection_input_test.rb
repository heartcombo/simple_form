# encoding: UTF-8
require 'test_helper'

class GroupedCollectionInputTest < ActionView::TestCase
  test 'input should have grouped options' do
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
end
