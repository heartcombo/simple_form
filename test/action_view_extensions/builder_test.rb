require 'test_helper'

class BuilderTest < ActionView::TestCase
  def with_custom_form_for(object, *args, &block)
    with_concat_custom_form_for(object) do |f|
      assert f.instance_of?(CustomFormBuilder)
      yield f
    end
  end

  def with_collection_radio(object, attribute, collection, value_method, text_method, options={}, html_options={})
    with_concat_form_for(object) do |f|
      f.collection_radio attribute, collection, value_method, text_method, options, html_options
    end
  end

  def with_collection_check_boxes(object, attribute, collection, value_method, text_method, options={}, html_options={})
    with_concat_form_for(object) do |f|
      f.collection_check_boxes attribute, collection, value_method, text_method, options, html_options
    end
  end

  # COLLECTION RADIO
  test 'collection radio accepts a collection and generate inputs from value method' do
    with_collection_radio @user, :active, [true, false], :to_s, :to_s

    assert_select 'form input[type=radio][value=true]#user_active_true'
    assert_select 'form input[type=radio][value=false]#user_active_false'
  end

  test 'collection radio accepts a collection and generate inputs from label method' do
    with_collection_radio @user, :active, [true, false], :to_s, :to_s

    assert_select 'form label.collection_radio[for=user_active_true]', 'true'
    assert_select 'form label.collection_radio[for=user_active_false]', 'false'
  end

  test 'collection radio handles camelized collection values for labels correctly' do
    with_collection_radio @user, :active, ['Yes', 'No'], :to_s, :to_s

    assert_select 'form label.collection_radio[for=user_active_yes]', 'Yes'
    assert_select 'form label.collection_radio[for=user_active_no]', 'No'
  end

  test 'colection radio should sanitize collection values for labels correctly' do
    with_collection_radio @user, :name, ['$0.99', '$1.99'], :to_s, :to_s
    assert_select 'label.collection_radio[for=user_name_099]', '$0.99'
    assert_select 'label.collection_radio[for=user_name_199]', '$1.99'
  end

  test 'collection radio accepts checked item' do
    with_collection_radio @user, :active, [[1, true], [0, false]], :last, :first, :checked => true

    assert_select 'form input[type=radio][value=true][checked=checked]'
    assert_no_select 'form input[type=radio][value=false][checked=checked]'
  end

  test 'collection radio accepts multiple disabled items' do
    collection = [[1, true], [0, false], [2, 'other']]
    with_collection_radio @user, :active, collection, :last, :first, :disabled => [true, false]

    assert_select 'form input[type=radio][value=true][disabled=disabled]'
    assert_select 'form input[type=radio][value=false][disabled=disabled]'
    assert_no_select 'form input[type=radio][value=other][disabled=disabled]'
  end

  test 'collection radio accepts single disable item' do
    collection = [[1, true], [0, false]]
    with_collection_radio @user, :active, collection, :last, :first, :disabled => true

    assert_select 'form input[type=radio][value=true][disabled=disabled]'
    assert_no_select 'form input[type=radio][value=false][disabled=disabled]'
  end

  test 'collection radio accepts html options as input' do
    collection = [[1, true], [0, false]]
    with_collection_radio @user, :active, collection, :last, :first, {}, :class => 'radio'

    assert_select 'form input[type=radio][value=true].radio#user_active_true'
    assert_select 'form input[type=radio][value=false].radio#user_active_false'
  end

  test 'collection radio wraps the collection in the configured collection wrapper tag' do
    swap SimpleForm, :collection_wrapper_tag => :ul do
      with_collection_radio @user, :active, [true, false], :to_s, :to_s

      assert_select 'form ul input[type=radio][value=true]#user_active_true'
      assert_select 'form ul input[type=radio][value=false]#user_active_false'
    end
  end

  test 'collection radio wraps the collection in the given collection wrapper tag' do
    with_collection_radio @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => :ul

    assert_select 'form ul input[type=radio][value=true]#user_active_true'
    assert_select 'form ul input[type=radio][value=false]#user_active_false'
  end

  test 'collection radio does not wrap the collection in the explicitly false collection wrapper tag' do
    swap SimpleForm, :collection_wrapper_tag => :ul do
      with_collection_radio @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => false

      assert_no_select 'form ul'
      assert_no_select 'form ul'
    end
  end

  test 'collection radio does not wrap the collection in the explicitly nil collection wrapper tag' do
    swap SimpleForm, :collection_wrapper_tag => :ul do
      with_collection_radio @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => nil

      assert_no_select 'form ul'
      assert_no_select 'form ul'
    end
  end

  test 'collection radio does not wrap the collection by default' do
    with_collection_radio @user, :active, [true, false], :to_s, :to_s

    assert_no_select 'form ul'
  end

  test 'collection radio wraps each label/radio in the configured item wrapper tag' do
    swap SimpleForm, :item_wrapper_tag => :li do
      with_collection_radio @user, :active, [true, false], :to_s, :to_s

      assert_select 'form li input[type=radio][value=true]#user_active_true'
      assert_select 'form li input[type=radio][value=false]#user_active_false'
    end
  end

  test 'collection radio wraps each label/radio in the given item wrapper tag' do
    with_collection_radio @user, :active, [true, false], :to_s, :to_s, :item_wrapper_tag => :li

    assert_select 'form li input[type=radio][value=true]#user_active_true'
    assert_select 'form li input[type=radio][value=false]#user_active_false'
  end

  test 'collection radio does not wrap each label/radio in the explicitly false item wrapper tag' do
    with_collection_radio @user, :active, [true, false], :to_s, :to_s, :item_wrapper_tag => false

    assert_no_select 'form span input[type=radio][value=true]#user_active_true'
    assert_no_select 'form span input[type=radio][value=false]#user_active_false'
  end

  test 'collection radio does not wrap each label/radio in the explicitly nil item wrapper tag' do
    with_collection_radio @user, :active, [true, false], :to_s, :to_s, :item_wrapper_tag => nil

    assert_no_select 'form span input[type=radio][value=true]#user_active_true'
    assert_no_select 'form span input[type=radio][value=false]#user_active_false'
  end

  test 'collection radio wrap items in a span tag by default' do
    with_collection_radio @user, :active, [true, false], :to_s, :to_s

    assert_select 'form span input[type=radio][value=true]#user_active_true + label'
    assert_select 'form span input[type=radio][value=false]#user_active_false + label'
  end

  test 'collection radio does not wrap input inside the label' do
    with_collection_radio @user, :active, [true, false], :to_s, :to_s

    assert_no_select 'form label input'
  end

  # COLLECTION CHECK BOX
  test 'collection check box accepts a collection and generate a serie of checkboxes for value method' do
    collection = [Tag.new(1, 'Tag 1'), Tag.new(2, 'Tag 2')]
    with_collection_check_boxes @user, :tag_ids, collection, :id, :name

    assert_select "form input[type=hidden][name='user[tag_ids][]'][value=]"
    assert_select 'form input#user_tag_ids_1[type=checkbox][value=1]'
    assert_select 'form input#user_tag_ids_2[type=checkbox][value=2]'
  end

  test 'collection check box accepts a collection and generate a serie of checkboxes with labels for label method' do
    collection = [Tag.new(1, 'Tag 1'), Tag.new(2, 'Tag 2')]
    with_collection_check_boxes @user, :tag_ids, collection, :id, :name

    assert_select 'form label.collection_check_boxes[for=user_tag_ids_1]', 'Tag 1'
    assert_select 'form label.collection_check_boxes[for=user_tag_ids_2]', 'Tag 2'
  end

  test 'collection check box handles camelized collection values for labels correctly' do
    with_collection_check_boxes @user, :active, ['Yes', 'No'], :to_s, :to_s

    assert_select 'form label.collection_check_boxes[for=user_active_yes]', 'Yes'
    assert_select 'form label.collection_check_boxes[for=user_active_no]', 'No'
  end

  test 'colection check box should sanitize collection values for labels correctly' do
    with_collection_check_boxes @user, :name, ['$0.99', '$1.99'], :to_s, :to_s
    assert_select 'label.collection_check_boxes[for=user_name_099]', '$0.99'
    assert_select 'label.collection_check_boxes[for=user_name_199]', '$1.99'
  end

  test 'collection check box accepts selected values as :checked option' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    with_collection_check_boxes @user, :tag_ids, collection, :first, :last, :checked => [1, 3]

    assert_select 'form input[type=checkbox][value=1][checked=checked]'
    assert_select 'form input[type=checkbox][value=3][checked=checked]'
    assert_no_select 'form input[type=checkbox][value=2][checked=checked]'
  end

  test 'collection check box accepts a single checked value' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    with_collection_check_boxes @user, :tag_ids, collection, :first, :last, :checked => 3

    assert_select 'form input[type=checkbox][value=3][checked=checked]'
    assert_no_select 'form input[type=checkbox][value=1][checked=checked]'
    assert_no_select 'form input[type=checkbox][value=2][checked=checked]'
  end

  test 'collection check box accepts multiple disabled items' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    with_collection_check_boxes @user, :tag_ids, collection, :first, :last, :disabled => [1, 3]

    assert_select 'form input[type=checkbox][value=1][disabled=disabled]'
    assert_select 'form input[type=checkbox][value=3][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=2][disabled=disabled]'
  end

  test 'collection check box accepts single disable item' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    with_collection_check_boxes @user, :tag_ids, collection, :first, :last, :disabled => 1

    assert_select 'form input[type=checkbox][value=1][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=3][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=2][disabled=disabled]'
  end

  test 'collection check box accepts a proc to disabled items' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    with_collection_check_boxes @user, :tag_ids, collection, :first, :last, :disabled => proc { |i| i.first == 1 }

    assert_select 'form input[type=checkbox][value=1][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=3][disabled=disabled]'
    assert_no_select 'form input[type=checkbox][value=2][disabled=disabled]'
  end

  test 'collection check box accepts html options' do
    collection = [[1, 'Tag 1'], [2, 'Tag 2']]
    with_collection_check_boxes @user, :tag_ids, collection, :first, :last, {}, :class => 'check'

    assert_select 'form input.check[type=checkbox][value=1]'
    assert_select 'form input.check[type=checkbox][value=2]'
  end

  test 'collection check box with fields for' do
    collection = [Tag.new(1, 'Tag 1'), Tag.new(2, 'Tag 2')]
    with_concat_form_for(@user) do |f|
      f.fields_for(:post) do |p|
        p.collection_check_boxes :tag_ids, collection, :id, :name
      end
    end

    assert_select 'form input#user_post_tag_ids_1[type=checkbox][value=1]'
    assert_select 'form input#user_post_tag_ids_2[type=checkbox][value=2]'

    assert_select 'form label.collection_check_boxes[for=user_post_tag_ids_1]', 'Tag 1'
    assert_select 'form label.collection_check_boxes[for=user_post_tag_ids_2]', 'Tag 2'
  end

  test 'collection check box wraps the collection in the configured collection wrapper tag' do
    swap SimpleForm, :collection_wrapper_tag => :ul do
      with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s

      assert_select 'form ul input[type=checkbox][value=true]#user_active_true'
      assert_select 'form ul input[type=checkbox][value=false]#user_active_false'
    end
  end

  test 'collection check box wraps the collection in the given collection wrapper tag' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => :ul

    assert_select 'form ul input[type=checkbox][value=true]#user_active_true'
    assert_select 'form ul input[type=checkbox][value=false]#user_active_false'
  end

  test 'collection check box does not wrap the collection in the explicitly false collection wrapper tag' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => false, :item_wrapper_tag => false

    assert_select 'form > input[type=checkbox][value=true]#user_active_true'
    assert_select 'form > input[type=checkbox][value=false]#user_active_false'
  end

  test 'collection check box does not wrap the collection by default' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s

    assert_no_select 'form ul'
  end

  test 'collection check box wraps each label/radio in the configured item wrapper tag' do
    swap SimpleForm, :item_wrapper_tag => :li do
      with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s

      assert_select 'form li input[type=checkbox][value=true]#user_active_true'
      assert_select 'form li input[type=checkbox][value=false]#user_active_false'
    end
  end

  test 'collection check box wraps each label/radio in the given item wrapper tag' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s, :item_wrapper_tag => :li

    assert_select 'form li input[type=checkbox][value=true]#user_active_true'
    assert_select 'form li input[type=checkbox][value=false]#user_active_false'
  end

  test 'collection check box does not wrapp each label/radio in the explicitly false item wrapper tag' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s, :item_wrapper_tag => false

    assert_select 'form > input[type=checkbox][value=true]#user_active_true'
    assert_select 'form > input[type=checkbox][value=false]#user_active_false'
  end

  test 'collection check box wrap items in a span tag by default' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s

    assert_select 'form span input[type=checkbox][value=true]#user_active_true + label'
    assert_select 'form span input[type=checkbox][value=false]#user_active_false + label'
  end

  test 'collection check box does not wrap input inside the label' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s

    assert_no_select 'form label input'
  end

  # SIMPLE FIELDS
  test 'simple fields for is available and yields an instance of FormBuilder' do
    with_concat_form_for(@user) do |f|
      f.simple_fields_for(:posts) do |posts_form|
        assert posts_form.instance_of?(SimpleForm::FormBuilder)
      end
    end
  end

  test 'fields for with a hash like model yeilds an instance of FormBuilder' do
    @hash_backed_author = HashBackedAuthor.new

    with_concat_form_for(:user) do |f|
      f.simple_fields_for(:author, @hash_backed_author) do |author|
        assert author.instance_of?(SimpleForm::FormBuilder)
        author.input :name
      end
    end

    assert_select "input[name='user[author][name]'][value='hash backed author']"
  end

  test 'fields for yields an instance of CustomBuilder if main builder is a CustomBuilder' do
    with_custom_form_for(:user) do |f|
      f.simple_fields_for(:company) do |company|
        assert company.instance_of?(CustomFormBuilder)
      end
    end
  end

  test 'fields for yields an instance of FormBuilder if it was set in options' do
    with_custom_form_for(:user) do |f|
      f.simple_fields_for(:company, :builder => SimpleForm::FormBuilder) do |company|
        assert company.instance_of?(SimpleForm::FormBuilder)
      end
    end
  end
end
