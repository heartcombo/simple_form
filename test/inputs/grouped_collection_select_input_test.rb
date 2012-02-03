# encoding: UTF-8
require 'test_helper'

class GroupedCollectionSelectInputTest < ActionView::TestCase
  test 'grouped collection accepts array collection form' do
    with_input_for @user, :tag_ids, :grouped_select,
      :collection => [['Authors', ['Jose', 'Carlos']], ['General', ['Bob', 'John']]],
      :group_method => :last

    assert_select 'select.grouped_select#user_tag_ids' do
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

  test 'grouped collection accepts empty array collection form' do
    with_input_for @user, :tag_ids, :grouped_select,
      :collection => [],
      :group_method => :last

    assert_select 'select.grouped_select#user_tag_ids'
  end


  test 'grouped collection accepts proc as collection' do
    with_input_for @user, :tag_ids, :grouped_select,
      :collection => Proc.new { [['Authors', ['Jose', 'Carlos']], ['General', ['Bob', 'John']]] },
      :group_method => :last

    assert_select 'select.grouped_select#user_tag_ids' do
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
    with_input_for @user, :tag_ids, :grouped_select,
      :collection => { 'Authors' => ['Jose', 'Carlos'], 'General' => ['Bob', 'John'] },
      :group_method => :last

    assert_select 'select.grouped_select#user_tag_ids' do
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
    with_input_for @user, :tag_ids, :grouped_select,
      :collection => { ['Jose', 'Carlos'] => 'Authors' },
      :group_method => :first,
      :group_label_method => :last

    assert_select 'select.grouped_select#user_tag_ids' do
      assert_select 'optgroup[label=Authors]' do
        assert_select 'option', 'Jose'
        assert_select 'option', 'Carlos'
      end
    end
  end

  test 'grouped collection accepts label and value methods options' do
    with_input_for @user, :tag_ids, :grouped_select,
      :collection => { 'Authors' => ['Jose', 'Carlos'] },
      :group_method => :last,
      :label_method => :upcase,
      :value_method => :downcase

    assert_select 'select.grouped_select#user_tag_ids' do
      assert_select 'optgroup[label=Authors]' do
        assert_select 'option[value=jose]', 'JOSE'
        assert_select 'option[value=carlos]', 'CARLOS'
      end
    end
  end

  test 'grouped collection with associations' do
    tag_groups = [
      TagGroup.new(1, "Group of Tags", [Tag.new(1, "Tag 1"), Tag.new(2, "Tag 2")]),
      TagGroup.new(2, "Other group", [Tag.new(3, "Tag 3"), Tag.new(4,"Tag 4")])
    ]

    with_input_for @user, :tag_ids, :grouped_select,
      :collection => tag_groups, :group_method => :tags

    assert_select 'select.grouped_select#user_tag_ids' do
      assert_select 'optgroup[label=Group of Tags]' do
        assert_select 'option[value=1]', 'Tag 1'
        assert_select 'option[value=2]', 'Tag 2'
      end

      assert_select 'optgroup[label=Other group]' do
        assert_select 'option[value=3]', 'Tag 3'
        assert_select 'option[value=4]', 'Tag 4'
      end
    end
  end
end
