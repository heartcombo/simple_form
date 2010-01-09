require 'test_helper'

class BuilderTest < ActionView::TestCase
  # COLLECTION RADIO
  test 'collection radio accepts a collection and generate inputs from value method' do
    form_for @user do |f|
      concat f.collection_radio :active, [true, false], :to_s, :to_s
    end

    assert_select 'form input[type=radio][value=true]#user_active_true'
    assert_select 'form input[type=radio][value=false]#user_active_false'
  end

  test 'collection radio accepts a collection and generate inputs from label method' do
    form_for @user do |f|
      concat f.collection_radio :active, [true, false], :to_s, :to_s
    end

    assert_select 'form label.collection_radio[for=user_active_true]', 'true'
    assert_select 'form label.collection_radio[for=user_active_false]', 'false'
  end

  test 'collection radio accepts checked item' do
    form_for @user do |f|
      concat f.collection_radio :active, [[1, true], [0, false]], :last, :first, :checked => true
    end

    assert_select 'form input[type=radio][value=true][checked=checked]'
    assert_no_select 'form input[type=radio][value=false][checked=checked]'
  end

  test 'collection radio accepts multiple disabled items' do
    collection = [[1, true], [0, false], [2, 'other']]
    form_for @user do |f|
      concat f.collection_radio :active, collection, :last, :first, :disabled => [true, false]
    end

    assert_select 'form input[type=radio][value=true][disabled=disabled]'
    assert_select 'form input[type=radio][value=false][disabled=disabled]'
    assert_no_select 'form input[type=radio][value=other][disabled=disabled]'
  end

  test 'collection radio accepts single disable item' do
    collection = [[1, true], [0, false]]
    form_for @user do |f|
      concat f.collection_radio :active, collection, :last, :first, :disabled => true
    end

    assert_select 'form input[type=radio][value=true][disabled=disabled]'
    assert_no_select 'form input[type=radio][value=false][disabled=disabled]'
  end

  test 'collection radio accepts html options as input' do
    form_for @user do |f|
      concat f.collection_radio :active, [[1, true], [0, false]], :last, :first, {}, :class => 'radio'
    end

    assert_select 'form input[type=radio][value=true].radio#user_active_true'
    assert_select 'form input[type=radio][value=false].radio#user_active_false'
  end

  # COLLECTION CHECK BOX
  test 'collection check box accepts a collection and generate a serie of checkboxes for value method' do
    collection = [Tag.new(1, 'Tag 1'), Tag.new(2, 'Tag 2')]
    form_for @user do |f|
      concat f.collection_check_boxes :tag_ids, collection, :id, :name
    end

    assert_select "form input[type=hidden][name='user[tag_ids][]'][value=]"
    assert_select 'form input#user_tag_ids_1[type=checkbox][value=1]'
    assert_select 'form input#user_tag_ids_2[type=checkbox][value=2]'
  end

  test 'collection check box accepts a collection and generate a serie of checkboxes with labels for label method' do
    collection = [Tag.new(1, 'Tag 1'), Tag.new(2, 'Tag 2')]
    form_for @user do |f|
      concat f.collection_check_boxes :tag_ids, collection, :id, :name
    end

    assert_select 'form label.collection_check_boxes[for=user_tag_ids_1]', 'Tag 1'
    assert_select 'form label.collection_check_boxes[for=user_tag_ids_2]', 'Tag 2'
  end

  test 'collection check box accepts selected values as :checked option' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    form_for @user do |f|
      concat f.collection_check_boxes :tag_ids, collection, :first, :last, :checked => [1, 3]
    end

    assert_select 'form input[type=checkbox][value=1][checked=checked]'
    assert_select 'form input[type=checkbox][value=3][checked=checked]'
    assert_no_select 'form input[type=checkbox][value=2][checked=checked]'
  end

  test 'collection check box accepts a single checked value' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    form_for @user do |f|
      concat f.collection_check_boxes :tag_ids, collection, :first, :last, :checked => 3
    end

    assert_select 'form input[type=checkbox][value=3][checked=checked]'
    assert_no_select 'form input[type=checkbox][value=1][checked=checked]'
    assert_no_select 'form input[type=checkbox][value=2][checked=checked]'
  end

  test 'collection check box accepts multiple disabled items' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    form_for @user do |f|
      concat f.collection_check_boxes :tag_ids, collection, :first, :last, :disabled => [1, 3]
    end

    assert_select 'form input[type=checkbox][value=1][disabled=disabled]'
    assert_select 'form input[type=checkbox][value=3][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=2][disabled=disabled]'
  end

  test 'collection check box accepts single disable item' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    form_for @user do |f|
      concat f.collection_check_boxes :tag_ids, collection, :first, :last, :disabled => 1
    end

    assert_select 'form input[type=checkbox][value=1][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=3][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=2][disabled=disabled]'
  end

  test 'collection check box accepts a proc to disabled items' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    form_for @user do |f|
      concat f.collection_check_boxes :tag_ids, collection, :first, :last, :disabled => proc { |i| i.first == 1 }
    end

    assert_select 'form input[type=checkbox][value=1][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=3][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=2][disabled=disabled]'
  end

  test 'collection check box accepts html options' do
    collection = [[1, 'Tag 1'], [2, 'Tag 2']]
    form_for @user do |f|
      concat f.collection_check_boxes :tag_ids, collection, :first, :last, {}, :class => 'check'
    end

    assert_select 'form input.check[type=checkbox][value=1]'
    assert_select 'form input.check[type=checkbox][value=2]'
  end

  test 'collection check box with fields for' do
    collection = [Tag.new(1, 'Tag 1'), Tag.new(2, 'Tag 2')]
    form_for @user do |f|
      f.fields_for :post do |p|
        concat p.collection_check_boxes :tag_ids, collection, :id, :name
      end
    end

    assert_select 'form input#user_post_tag_ids_1[type=checkbox][value=1]'
    assert_select 'form input#user_post_tag_ids_2[type=checkbox][value=2]'

    assert_select 'form label.collection_check_boxes[for=user_post_tag_ids_1]', 'Tag 1'
    assert_select 'form label.collection_check_boxes[for=user_post_tag_ids_2]', 'Tag 2'
  end

  # SIMPLE FIELDS
  test 'simple fields for is available and yields an instance of FormBuilder' do
    form_for @user do |f|
      f.simple_fields_for :posts do |posts_form|
        assert posts_form.instance_of?(SimpleForm::FormBuilder)
      end
    end
  end
end
