require 'test_helper'

class BuilderTest < ActionView::TestCase
  def with_custom_form_for(object, *args, &block)
    with_concat_custom_form_for(object) do |f|
      assert f.instance_of?(CustomFormBuilder)
      yield f
    end
  end

  def with_collection_radio_buttons(object, attribute, collection, value_method, text_method, options={}, html_options={}, &block)
    with_concat_form_for(object) do |f|
      f.collection_radio_buttons attribute, collection, value_method, text_method, options, html_options, &block
    end
  end

  def with_collection_check_boxes(object, attribute, collection, value_method, text_method, options={}, html_options={}, &block)
    with_concat_form_for(object) do |f|
      f.collection_check_boxes attribute, collection, value_method, text_method, options, html_options, &block
    end
  end

  # COLLECTION RADIO
  test 'collection radio accepts a collection and generate inputs from value method' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s

    assert_select 'form input[type=radio][value=true]#user_active_true'
    assert_select 'form input[type=radio][value=false]#user_active_false'
  end

  test 'collection radio accepts a collection and generate inputs from label method' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s

    assert_select 'form label.collection_radio_buttons[for=user_active_true]', 'true'
    assert_select 'form label.collection_radio_buttons[for=user_active_false]', 'false'
  end

  test 'collection radio handles camelized collection values for labels correctly' do
    with_collection_radio_buttons @user, :active, ['Yes', 'No'], :to_s, :to_s

    assert_select 'form label.collection_radio_buttons[for=user_active_yes]', 'Yes'
    assert_select 'form label.collection_radio_buttons[for=user_active_no]', 'No'
  end

  test 'colection radio should sanitize collection values for labels correctly' do
    with_collection_radio_buttons @user, :name, ['$0.99', '$1.99'], :to_s, :to_s
    assert_select 'label.collection_radio_buttons[for=user_name_099]', '$0.99'
    assert_select 'label.collection_radio_buttons[for=user_name_199]', '$1.99'
  end

  test 'collection radio accepts checked item' do
    with_collection_radio_buttons @user, :active, [[1, true], [0, false]], :last, :first, :checked => true

    assert_select 'form input[type=radio][value=true][checked=checked]'
    assert_no_select 'form input[type=radio][value=false][checked=checked]'
  end

  test 'collection radio accepts multiple disabled items' do
    collection = [[1, true], [0, false], [2, 'other']]
    with_collection_radio_buttons @user, :active, collection, :last, :first, :disabled => [true, false]

    assert_select 'form input[type=radio][value=true][disabled=disabled]'
    assert_select 'form input[type=radio][value=false][disabled=disabled]'
    assert_no_select 'form input[type=radio][value=other][disabled=disabled]'
  end

  test 'collection radio accepts single disable item' do
    collection = [[1, true], [0, false]]
    with_collection_radio_buttons @user, :active, collection, :last, :first, :disabled => true

    assert_select 'form input[type=radio][value=true][disabled=disabled]'
    assert_no_select 'form input[type=radio][value=false][disabled=disabled]'
  end

  test 'collection radio accepts html options as input' do
    collection = [[1, true], [0, false]]
    with_collection_radio_buttons @user, :active, collection, :last, :first, {}, :class => 'special-radio'

    assert_select 'form input[type=radio][value=true].special-radio#user_active_true'
    assert_select 'form input[type=radio][value=false].special-radio#user_active_false'
  end

  test 'collection radio wraps the collection in the given collection wrapper tag' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => :ul

    assert_select 'form ul input[type=radio]', :count => 2
  end

  test 'collection radio does not render any wrapper tag by default' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s

    assert_select 'form input[type=radio]', :count => 2
    assert_no_select 'form ul'
  end

  test 'collection radio does not wrap the collection when given falsy values' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => false

    assert_select 'form input[type=radio]', :count => 2
    assert_no_select 'form ul'
  end

  test 'collection radio uses the given class for collection wrapper tag' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s,
      :collection_wrapper_tag => :ul, :collection_wrapper_class => "items-list"

    assert_select 'form ul.items-list input[type=radio]', :count => 2
  end

  test 'collection radio uses no class for collection wrapper tag when no wrapper tag is given' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s,
      :collection_wrapper_class => "items-list"

    assert_select 'form input[type=radio]', :count => 2
    assert_no_select 'form ul'
    assert_no_select '.items-list'
  end

  test 'collection radio uses no class for collection wrapper tag by default' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => :ul

    assert_select 'form ul'
    assert_no_select 'form ul[class]'
  end

  test 'collection radio wrap items in a span tag by default' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s

    assert_select 'form span input[type=radio][value=true]#user_active_true + label'
    assert_select 'form span input[type=radio][value=false]#user_active_false + label'
  end

  test 'collection radio wraps each item in the given item wrapper tag' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s, :item_wrapper_tag => :li

    assert_select 'form li input[type=radio]', :count => 2
  end

  test 'collection radio does not wrap each item when given explicitly falsy value' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s, :item_wrapper_tag => false

    assert_select 'form input[type=radio]'
    assert_no_select 'form span input[type=radio]'
  end

  test 'collection radio uses the given class for item wrapper tag' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s,
      :item_wrapper_tag => :li, :item_wrapper_class => "inline"

    assert_select "form li.inline input[type=radio]", :count => 2
  end

  test 'collection radio uses no class for item wrapper tag when no wrapper tag is given' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s,
      :item_wrapper_tag => nil, :item_wrapper_class => "inline"

    assert_select 'form input[type=radio]', :count => 2
    assert_no_select 'form li'
    assert_no_select '.inline'
  end

  test 'collection radio uses no class for item wrapper tag by default' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s,
      :item_wrapper_tag => :li

    assert_select "form li", :count => 2
    assert_no_select "form li[class]"
  end

  test 'collection radio does not wrap input inside the label' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s

    assert_select 'form input[type=radio] + label'
    assert_no_select 'form label input'
  end

  test 'collection radio accepts a block to render the radio and label as required' do
    with_collection_radio_buttons @user, :active, [true, false], :to_s, :to_s do |label_for, text, value, html_options|
      label(:user, label_for, text) { radio_button(:user, :active, value, html_options) }
    end

    assert_select 'form label[for=user_active_true] > input#user_active_true[type=radio]'
    assert_select 'form label[for=user_active_false] > input#user_active_false[type=radio]'
  end

  test 'collection_radio helper is deprecated in favor of collection_radio_buttons' do
    assert_deprecated "[SIMPLE_FORM] The `collection_radio` helper is deprecated, " \
      "please use `collection_radio_buttons` instead" do
      with_concat_form_for(@user) do |f|
        f.collection_radio :active, [true, false], :to_s, :to_s
      end
    end

    assert_select 'input[type=radio][value=true]'
    assert_select 'input[type=radio][value=false]'
  end

  # COLLECTION CHECK BOX
  test 'collection check box accepts a collection and generate a serie of checkboxes for value method' do
    collection = [Tag.new(1, 'Tag 1'), Tag.new(2, 'Tag 2')]
    with_collection_check_boxes @user, :tag_ids, collection, :id, :name

    assert_select 'form input#user_tag_ids_1[type=checkbox][value=1]'
    assert_select 'form input#user_tag_ids_2[type=checkbox][value=2]'
  end

  test 'collection check box generates only one hidden field for the entire collection, to ensure something will be sent back to the server when posting an empty collection' do
    collection = [Tag.new(1, 'Tag 1'), Tag.new(2, 'Tag 2')]
    with_collection_check_boxes @user, :tag_ids, collection, :id, :name

    assert_select "form input[type=hidden][name='user[tag_ids][]'][value=]", :count => 1
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

  test 'collection check box accepts selected values as :checked option and override the model values' do
    collection = (1..3).map{|i| [i, "Tag #{i}"] }
    @user.tag_ids = [2]
    with_collection_check_boxes @user, :tag_ids, collection, :first, :last, :checked => [1, 3]

    assert_select 'form input[type=checkbox][value=1][checked=checked]'
    assert_select 'form input[type=checkbox][value=3][checked=checked]'
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

  test 'collection check boxes wraps the collection in the given collection wrapper tag' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => :ul

    assert_select 'form ul input[type=checkbox]', :count => 2
  end

  test 'collection check boxes does not render any wrapper tag by default' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s

    assert_select 'form input[type=checkbox]', :count => 2
    assert_no_select 'form ul'
  end

  test 'collection check boxes does not wrap the collection when given falsy values' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => false

    assert_select 'form input[type=checkbox]', :count => 2
    assert_no_select 'form ul'
  end

  test 'collection check boxes uses the given class for collection wrapper tag' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s,
      :collection_wrapper_tag => :ul, :collection_wrapper_class => "items-list"

    assert_select 'form ul.items-list input[type=checkbox]', :count => 2
  end

  test 'collection check boxes uses no class for collection wrapper tag when no wrapper tag is given' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s,
      :collection_wrapper_class => "items-list"

    assert_select 'form input[type=checkbox]', :count => 2
    assert_no_select 'form ul'
    assert_no_select '.items-list'
  end

  test 'collection check boxes uses no class for collection wrapper tag by default' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s, :collection_wrapper_tag => :ul

    assert_select 'form ul'
    assert_no_select 'form ul[class]'
  end

  test 'collection check boxes wrap items in a span tag by default' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s

    assert_select 'form span input[type=checkbox]', :count => 2
  end

  test 'collection check boxes wraps each item in the given item wrapper tag' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s, :item_wrapper_tag => :li

    assert_select 'form li input[type=checkbox]', :count => 2
  end

  test 'collection check boxes does not wrap each item when given explicitly falsy value' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s, :item_wrapper_tag => false

    assert_select 'form input[type=checkbox]'
    assert_no_select 'form span input[type=checkbox]'
  end

  test 'collection check boxes uses the given class for item wrapper tag' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s,
      :item_wrapper_tag => :li, :item_wrapper_class => "inline"

    assert_select "form li.inline input[type=checkbox]", :count => 2
  end

  test 'collection check boxes uses no class for item wrapper tag when no wrapper tag is given' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s,
      :item_wrapper_tag => nil, :item_wrapper_class => "inline"

    assert_select 'form input[type=checkbox]', :count => 2
    assert_no_select 'form li'
    assert_no_select '.inline'
  end

  test 'collection check boxes uses no class for item wrapper tag by default' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s,
      :item_wrapper_tag => :li

    assert_select "form li", :count => 2
    assert_no_select "form li[class]"
  end

  test 'collection check box does not wrap input inside the label' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s

    assert_select 'form input[type=checkbox] + label'
    assert_no_select 'form label input'
  end

  test 'collection check box accepts a block to render the radio and label as required' do
    with_collection_check_boxes @user, :active, [true, false], :to_s, :to_s do |label_for, text, value, html_options|
      label(:user, label_for, text) { check_box(:user, :active, html_options, value) }
    end

    assert_select 'form label[for=user_active_true] > input#user_active_true[type=checkbox]'
    assert_select 'form label[for=user_active_false] > input#user_active_false[type=checkbox]'
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

  test 'fields inherites wrapper option from the parent form' do
    swap_wrapper :another do
      simple_form_for(:user, :wrapper => :another) do |f|
        f.simple_fields_for(:company) do |company|
          assert_equal :another, company.options[:wrapper]
        end
      end
    end
  end
end
